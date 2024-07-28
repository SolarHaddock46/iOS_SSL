import UIKit

class LoginAssembly {
    static func build() -> LoginViewController {
        let router = SSLRouter()
        let viewController = LoginViewController(router: router)
        let presenter = LoginPresenter(viewController: viewController)
        let interactor = LoginInteractor()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
