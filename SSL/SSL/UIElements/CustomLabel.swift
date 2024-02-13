import UIKit

class CustomLabel: UILabel {
    init(localisationKey: String) {
        super.init(frame: .zero)
        setup(localisationKey: localisationKey)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setup(localisationKey: String) {
        self.text = NSLocalizedString(localisationKey, comment: "comment")
        self.textColor = .white
        if let customFont = UIFont(name: "Onest", size: 16) {
            self.font = customFont
        } else {
            self.font = UIFont.systemFont(ofSize: 16)
        }
    }
}
