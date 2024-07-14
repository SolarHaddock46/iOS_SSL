import Foundation

protocol LoginInteractorProtocol {
    var presenter: LoginPresenterProtocol? { get set }
    func login(email: String, password: String) async throws
}

protocol LoginPresenterProtocol: AnyObject {
    var viewController: LoginViewControllerProtocol? { get set }
    func presentLoginResult(result: Result<LoginResponseDTO, NetworkError>)
}

protocol LoginViewControllerProtocol: AnyObject {
    var interactor: LoginInteractorProtocol? { get set }
    func showAlert(title: String, message: String)
}
