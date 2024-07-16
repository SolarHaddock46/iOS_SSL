import UIKit

class SSLLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(localisationKey: "", color: .mainTextColor, size: 16)
    }

    convenience init(localisationKey: String) {
        self.init(frame: .zero)
        setup(localisationKey: localisationKey, color: .mainTextColor, size: 16)
    }

    init(localisationKey: String, color: UIColor) {
        super.init(frame: .zero)
        setup(localisationKey: localisationKey, color: color, size: 16)
    }
    
    init(localizationKey: String, isHeading: Bool) {
        super.init(frame: .zero)
        setup(localisationKey: localizationKey, color: .mainTextColor, size: 28, isMedium: true)
    }
    
    init(localizationKey: String, isSubtext: Bool) {
        super.init(frame: .zero)
        setup(localisationKey: localizationKey, color: .subTextColor, size: 16)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(localisationKey: String, color: UIColor, size: CGFloat, isMedium: Bool = false) {
        self.textColor = color
        if isMedium {
            self.font = UIFont.onestMedium(ofSize: size)
        } else {
            self.font = UIFont.onest(ofSize: size)
        }
        self.text = NSLocalizedString(localisationKey, comment: "comment")
        
        self.numberOfLines = 0
        self.setContentHuggingPriority(.required, for: .vertical)
        self.setContentCompressionResistancePriority(.required, for: .vertical)
    }
}
