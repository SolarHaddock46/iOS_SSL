import Foundation

final class RegisterInteractor: RegisterPresenterToInteractorProtocol {
    var presenter: RegisterInteractorToPresenterProtocol?
    let networkError = NetworkError.self
    
    func performRegister(with user: RegisterRequestDTO) async throws {
        do {
            let userDTO = try await LoginAPIManager.postRegister(firstName: user.firstName, secondName: user.secondName, fatherName: user.fatherName, telegram: user.telegram, email: user.email, password1: user.password1, password2: user.password2, image: user.image, hsePass: user.hsePass, acceptConditions: true)
            self.presenter?.registerSuccess(with: userDTO)
        } catch {
            if let networkError = error as? NetworkError {
                self.presenter?.registerFailed(with: networkError)
            } else {
                self.presenter?.registerFailed(with: self.networkError.unknownError)
            }
        }
    }
}
