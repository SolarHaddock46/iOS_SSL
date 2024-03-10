import UIKit

class CustomLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(localisationKey: "", color: .black) 
    }
    
    convenience init(localisationKey: String) {
        self.init(frame: .zero)
        setup(localisationKey: localisationKey, color: .black)
    }
    
    init(localisationKey: String, color: UIColor) {
        super.init(frame: .zero)
        setup(localisationKey: localisationKey, color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(localisationKey: String, color: UIColor) {
        self.textColor = color
        if let customFont = UIFont(name: "Onest", size: 16) {
            self.font = customFont
        } else {
            self.font = UIFont.systemFont(ofSize: 16)
        }
        self.text = NSLocalizedString(localisationKey, comment: "comment")
    }
}
