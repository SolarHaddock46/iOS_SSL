import UIKit

extension UIFont {
    static func onest(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Onest", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func onestBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Onest-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
}
