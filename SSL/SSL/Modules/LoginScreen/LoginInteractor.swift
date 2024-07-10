import Foundation

protocol LoginInteractorProtocol {
    var presenter: LoginPresenterProtocol? { get set }
    func login(email: String, password: String) async throws
}

class LoginInteractor: LoginInteractorProtocol {
    
    var presenter: LoginPresenterProtocol?
    
    func login(email: String, password: String) async throws {
        do {
            let user = LoginRequestDTO(email: email, password: password)
            let userDTO = try await LoginAPIManager.postLogin(email: user.email, password: user.password)
            self.presenter?.loginSuccess(with: userDTO)
        } catch let error as NetworkError {
            self.presenter?.loginFailed(with: error)
        } catch {
            self.presenter?.loginFailed(with: NetworkError.unknownError)
        }
    }
}
