import Foundation
import UIKit

enum ProfileAssembly {
    static func build() -> UIViewController {
        let router = SSLRouter()
        let presenter = ProfilePresenter()
        let interactor = ProfileInteractor(presenter: presenter)
        let viewController = ProfileViewController(interactor: interactor, router: router)
        
        return viewController
    }
}
