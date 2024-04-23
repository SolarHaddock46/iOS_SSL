import Foundation

protocol RegisterInteractorProtocol: AnyObject {
    var presenter: RegisterPresenterProtocol? { get set }
    func register(firstName: String, lastName: String, fatherName: String, telegram: String, email: String, password1: String, password2: String, image: String, hsePass: Bool, acceptConditions: Bool) async throws
}

class RegisterInteractor: RegisterInteractorProtocol {
    var presenter: RegisterPresenterProtocol?
    let networkError = NetworkError.self
    
    func register(firstName: String, lastName: String, fatherName: String, telegram: String, email: String, password1: String, password2: String, image: String, hsePass: Bool, acceptConditions: Bool) async throws {
        do {
            let user = RegisterRequestDTO(first_name: firstName, last_name: lastName, father_name: fatherName, telegram: telegram, email: email, password1: password1, password2: password2, image: image, hse_pass: hsePass, accept_conditions: acceptConditions)
            let userDTO = try await RegisterAPIManager.postRegister(first_name: user.first_name, last_name: user.last_name, father_name: user.father_name, telegram: user.telegram, email: user.email, password1: user.password1, password2: user.password2, image: user.image, hse_pass: user.hse_pass, accept_conditions: user.accept_conditions)
            self.presenter?.registerSuccess(with: userDTO)
        } catch {
            if let networkError = error as? NetworkError {
                self.presenter?.registerFailed(with: networkError)
            } else {
                self.presenter?.registerFailed(with: self.networkError.unknownError)
                print(error.localizedDescription)
            }
        }
    }
}
