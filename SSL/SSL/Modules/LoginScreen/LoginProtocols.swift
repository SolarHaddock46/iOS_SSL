import Foundation
import UIKit

protocol LoginInteractorToPresenterProtocol {
    func loginSuccess(with response: UserDTO)
    func loginFailed(with error: NetworkError)
}

protocol LoginPresenterToInteractorProtocol {
    var presenter: LoginInteractorToPresenterProtocol? { get set }
    func performLogin(with user: LoginRequestDTO) async throws
}

protocol LoginViewToPresenterProtocol {
    var view: LoginPresenterToViewProtocol? { get set }
    var interactor: LoginPresenterToInteractorProtocol? { get set }
    var router: LoginPresenterToRouterProtocol? { get set }
    func startLogin(email: String, password: String) async throws
}

protocol LoginPresenterToViewProtocol {
    var presenter: LoginViewToPresenterProtocol? { get set }
    func showAlert(title: String, message: String)
    func hideLoading()
}

protocol LoginPresenterToRouterProtocol {
    static func createModule() -> UIViewController
}
