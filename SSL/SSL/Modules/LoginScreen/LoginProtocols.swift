import Foundation
import UIKit

protocol InteractorToPresenterProtocol {
    func loginSuccess(with response: UserDTO)
    func loginFailed(with error: String)
}

protocol PresenterToInteractorProtocol {
    var presenter: InteractorToPresenterProtocol? { get set }
    func performLogin(with user: UserDTO)
}

protocol ViewToPresenterProtocol {
    var view: PresenterToViewProtocol? { get set }
    var interactor: PresenterToInteractorProtocol? { get set }
    var router: PresenterToRouterProtocol? { get set }
    func startLogin(email: String, password: String)
}

protocol PresenterToViewProtocol {
    var presenter: ViewToPresenterProtocol? { get set }
}

protocol PresenterToRouterProtocol {
    static func createModule() -> UIViewController
}
