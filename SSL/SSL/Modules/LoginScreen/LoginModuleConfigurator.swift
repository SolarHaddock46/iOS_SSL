import UIKit

class LoginModuleConfigurator {
    static func configureModule() -> LoginViewController {
        let loginViewController = LoginViewController()
        let loginInteractor = LoginInteractor()
        let loginPresenter = LoginPresenter()
        
        loginViewController.interactor = loginInteractor
        loginInteractor.presenter = loginPresenter
        loginPresenter.viewController = loginViewController
        
        return loginViewController
    }
}
