import Foundation

// Defines the protocol for the Login View Controller.
protocol LoginViewControllerProtocol: AnyObject {
    var interactor: LoginInteractorProtocol? { get set }
    func displayLoginSuccess(message: String)
    func displayLoginError(message: String)
}

// Defines the protocol for the Login Interactor.
protocol LoginInteractorProtocol: AnyObject {
    var presenter: LoginPresenterProtocol? { get set }
    func login(email: String, password: String) async throws
}

// Defines the protocol for the Login Presenter.
protocol LoginPresenterProtocol: AnyObject {
    var viewController: LoginViewControllerProtocol? { get set }
    func presentLoginResult(result: Result<LoginResponseDTO, Error>)
}
