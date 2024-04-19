import Foundation

protocol RegisterPresenterProtocol: AnyObject {
    var viewController: RegisterViewControllerProtocol? { get set }
    func registerSuccess(with response: UserRegisterDTO)
    func registerFailed(with error: NetworkError)
}

class RegisterPresenter: RegisterPresenterProtocol {
    weak var viewController: RegisterViewControllerProtocol?
    
    func registerSuccess(with response: UserRegisterDTO) {
        viewController?.showAlert(title: "Success", message: response.first_name)
    }

    func registerFailed(with error: NetworkError) {
        viewController?.showAlert(title: "Error", message: error.localizedDescription)
    }}
