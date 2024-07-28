import Foundation
import UIKit

enum Destination {
    case registerFirst
    case registerSecond
    case forgotPassword
    case confirmationCode
    case newPassword
    case success
}

protocol SSLRoutingLogic {
    func navigate(source: UIViewController, destination: Destination, data: Any?)
}

final class SSLRouter: SSLRoutingLogic {
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
            let vc = ForgotPasswordEmailAssembly.build()
            source.navigationController?.pushViewController(vc, animated: true)
        case .confirmationCode:
            let vc = ConfirmationCodeAssembly.build()
            source.navigationController?.pushViewController(vc, animated: true)
        case .newPassword:
            let vc = NewPasswordAssembly.build()
            source.navigationController?.pushViewController(vc, animated: true)
        case .success:
            let vc = SuccessAssembly.build()
            source.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
