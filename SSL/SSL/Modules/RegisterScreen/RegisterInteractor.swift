import Foundation

protocol RegisterInteractorProtocol: AnyObject {
    var presenter: RegisterPresenterProtocol? { get set }
    func register(firstName: String, secondName: String, fatherName: String, telegram: String, email: String, password1: String, password2: String, image: String, hsePass: Bool, acceptConditions: Bool) async throws
}

class RegisterInteractor: RegisterInteractorProtocol {
    var presenter: RegisterPresenterProtocol?
    let networkError = NetworkError.self
    
    func register(firstName: String, secondName: String, fatherName: String, telegram: String, email: String, password1: String, password2: String, image: String, hsePass: Bool, acceptConditions: Bool) async throws {
        do {
            let user = RegisterRequestDTO(firstName: firstName, secondName: secondName, fatherName: fatherName, telegram: telegram, email: email, password1: password1, password2: password2, image: image, hsePass: hsePass, acceptConditions: acceptConditions)
            let userDTO = try await RegisterAPIManager.postRegister(firstName: user.firstName, secondName: user.secondName, fatherName: user.fatherName, telegram: user.telegram, email: user.email, password1: user.password1, password2: user.password2, image: user.image, hsePass: user.hsePass, acceptConditions: user.acceptConditions)
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
