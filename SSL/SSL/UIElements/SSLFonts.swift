import UIKit

extension UIFont {
    static func onest(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Onest", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func onestBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Onest-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    static func rubikExtraBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Rubik-ExtraBold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    static func onestMedium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Onest-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
