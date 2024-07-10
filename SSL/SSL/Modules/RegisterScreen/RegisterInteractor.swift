import Foundation

protocol RegisterInteractorProtocol: AnyObject {
    var presenter: RegisterPresenterProtocol? { get set }
    func register(firstName: String, lastName: String, fatherName: String, telegram: String, email: String, password1: String, password2: String, image: Data?, hsePass: Bool, acceptConditions: Bool) async throws
}

class RegisterInteractor: RegisterInteractorProtocol {
    
    var presenter: RegisterPresenterProtocol?
    let networkError = NetworkError.self
    
    func register(firstName: String, lastName: String, fatherName: String, telegram: String, email: String, password1: String, password2: String, image: Data?, hsePass: Bool, acceptConditions: Bool) async throws {
        do {
            let userDTO = try await RegisterAPIManager.postRegister(
                firstName: firstName,
                lastName: lastName,
                fatherName: fatherName,
                telegram: telegram,
                email: email,
                password1: password1,
                password2: password2,
                imageData: image,
                hsePass: hsePass,
                acceptConditions: acceptConditions
            )
            self.presenter?.registerSuccess(with: userDTO)
        } catch let error as NetworkError {
            self.presenter?.registerFailed(with: error)
        } catch {
            self.presenter?.registerFailed(with: self.networkError.unknownError)
            print(error.localizedDescription)
        }
    }
}
