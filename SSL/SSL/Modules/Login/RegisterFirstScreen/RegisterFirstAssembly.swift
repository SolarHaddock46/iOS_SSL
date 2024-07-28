import UIKit

enum RegisterFirstAssembly {
    static func build() -> UIViewController {
        let router = SSLRouter()
        let viewController = RegisterFirstViewController(router: router)
        return viewController
    }
}
