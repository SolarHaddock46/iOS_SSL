import UIKit

class SSLLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(localizationKey: "", color: .mainTextColor, size: 16)
    }

    convenience init(localizationKey: String) {
        self.init(frame: .zero)
        setup(localizationKey: localizationKey, color: .mainTextColor, size: 16)
    }
    
    init(localizationKey: String, size: CGFloat) {
        super.init(frame: .zero)
        setup(localizationKey: localizationKey, color: .mainTextColor, size: size)
    }

    init(localizationKey: String, color: UIColor) {
        super.init(frame: .zero)
        setup(localizationKey: localizationKey, color: color, size: 16)
    }
    
    init(localizationKey: String, isHeading: Bool) {
        super.init(frame: .zero)
        setup(localizationKey: localizationKey, color: .mainTextColor, size: 28, isMedium: true)
    }
    
    init(localizationKey: String, isSubtext: Bool) {
        super.init(frame: .zero)
        setup(localizationKey: localizationKey, color: .subTextColor, size: 16)
    }
    
    init(localizationKey: String, color: UIColor, size: CGFloat, isMedium: Bool) {
        super.init(frame: .zero)
        setup(localizationKey: localizationKey, color: color, size: size, isMedium: isMedium)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(localizationKey: String, color: UIColor, size: CGFloat, isMedium: Bool = false) {
        self.textColor = color
        if isMedium {
            self.font = UIFont.onestMedium(ofSize: size)
        } else {
            self.font = UIFont.onest(ofSize: size)
        }
        self.text = NSLocalizedString(localizationKey, comment: "comment")
        
        self.numberOfLines = 0
        self.setContentHuggingPriority(.required, for: .vertical)
        self.setContentCompressionResistancePriority(.required, for: .vertical)
    }
}
