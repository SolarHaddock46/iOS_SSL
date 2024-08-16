import Foundation

class RegisterSecondAssembly {
    
    static func build(formData: RegisterFirstFormData) -> RegisterSecondViewController {
        let router = SSLRouter()
        let interactor = RegisterSecondInteractor()
        let viewController = RegisterSecondViewController(formData: formData, interactor: interactor, router: router)
        let presenter = RegisterSecondPresenter(viewController: viewController)
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
