import Foundation
import UIKit

class RegisterRouter: RegisterPresenterToRouterProtocol {
    static func createModule() -> UIViewController {
        let view = RegisterFirstViewController()
        let presenter = RegisterPresenter()
        let interactor = RegisterInteractor()
        let router = RegisterRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        return view
    }
}

