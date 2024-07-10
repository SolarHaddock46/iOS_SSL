import Foundation

class RegisterBuilder {
    
    static func build() -> RegisterViewController {
        let registerViewController = RegisterViewController()
        let registerPresenter = RegisterPresenter()
        let registerInteractor = RegisterInteractor()
        
        registerViewController.interactor = registerInteractor
        registerInteractor.presenter = registerPresenter
        registerPresenter.viewController = registerViewController
        
        return registerViewController
    }
}
