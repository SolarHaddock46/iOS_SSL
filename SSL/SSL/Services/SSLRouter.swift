import Foundation
import UIKit

enum Destination {
    case registerFirst
    case registerSecond
    case forgotPassword
}

protocol RoutingLogic {
    func navigate(source: UIViewController, destination: Destination, data: Any?)
}

final class SSLRouter: RoutingLogic {
    weak var viewController: UIViewController?
    
    func navigate(source: UIViewController, destination: Destination, data: Any?) {
        switch destination {
        case .registerFirst:
            let vc = RegisterFirstAssembly.build()
            source.navigationController?.pushViewController(vc, animated: true)
        case .registerSecond:
            if let formData = data as? RegisterFirstFormData {
                let vc = RegisterSecondAssembly.build(formData: formData)
                source.navigationController?.pushViewController(vc, animated: true)
            }
        case .forgotPassword:
            // Handle forgot password navigation
            print("forgot password")
        }
    }
}
