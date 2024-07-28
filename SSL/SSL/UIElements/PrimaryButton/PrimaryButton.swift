import UIKit

final class PrimaryButton: UIButton {

    init(localizationKey: String) {
        super.init(frame: .zero)
        setup(localizationKey: localizationKey)
    }
    
    init(localizationKey: String, color: UIColor, textColor: UIColor) {
        super.init(frame: .zero)
        setup(localizationKey: localizationKey, color: color, textColor: textColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(localizationKey: String, color: UIColor = .buttonBackgroundColor, textColor: UIColor = .white) {
        backgroundColor = color
        layer.cornerRadius = 10
        heightAnchor.constraint(equalToConstant: 48).isActive = true
        let titleLabel = SSLLabel(localizationKey: localizationKey, color: textColor)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
