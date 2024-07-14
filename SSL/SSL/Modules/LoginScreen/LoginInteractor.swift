import Foundation

class LoginInteractor: LoginInteractorProtocol {
    var presenter: LoginPresenterProtocol?

    func login(email: String, password: String) async throws {
        do {
            let user = LoginRequestDTO(email: email, password: password)
            let userDTO = try await LoginWorker.postLogin(email: user.email, password: user.password)
            presenter?.presentLoginResult(result: .success(userDTO))
        } catch let error as NetworkError {
            presenter?.presentLoginResult(result: .failure(error))
        } catch {
            presenter?.presentLoginResult(result: .failure(NetworkError.unknownError))
        }
    }
}
