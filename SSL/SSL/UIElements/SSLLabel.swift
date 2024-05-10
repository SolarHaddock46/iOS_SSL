import UIKit

class SSLLabel: UILabel {

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
        self.font = UIFont.onest(ofSize: 16) 
        self.text = NSLocalizedString(localisationKey, comment: "comment")
    }
}
