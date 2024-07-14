import Foundation
import UIKit

protocol RegisterPresenterProtocol: AnyObject {
    var viewController: RegisterViewControllerProtocol? { get set }
    func registerSuccess(with response: RegisterResponse)
    func registerFailed(with error: NetworkError)
}

class RegisterPresenter: RegisterPresenterProtocol {
    
    weak var viewController: RegisterViewControllerProtocol?
    private var dialogPresenter: LoginDialog?

    func registerSuccess(with response: RegisterResponse) {
        dialogPresenter?.showAlert(title: "Success", message: response.firstName)
    }

    func registerFailed(with error: NetworkError) {
        dialogPresenter?.showAlert(title: "Error", message: error.localizedDescription)
    }
}
