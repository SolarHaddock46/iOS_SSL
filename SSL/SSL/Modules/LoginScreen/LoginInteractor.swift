import Foundation

final class LoginInteractor: PresenterToInteractorProtocol {
    var presenter: InteractorToPresenterProtocol?
    let networkError = NetworkError.self
    
    func performLogin(with user: UserDTO) async throws {
        do {
            let userDTO = try await LoginAPIManager.postLogin(email: user.email, password: user.password)
            self.presenter?.loginSuccess(with: userDTO)
        } catch {
            if let networkError = error as? NetworkError {
                self.presenter?.loginFailed(with: networkError)
            } else {
                self.presenter?.loginFailed(with: self.networkError.unknownError)
            }
        }
    }
}
