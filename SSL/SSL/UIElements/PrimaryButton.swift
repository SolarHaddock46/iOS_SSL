import UIKit

final class PrimaryButton: UIButton {

    init(localizationKey: String) {
        super.init(frame: .zero)
        backgroundColor = UIColor(red: 63/255, green: 162/255, blue: 254/255, alpha: 1.0)
        layer.cornerRadius = 16
        heightAnchor.constraint(equalToConstant: 48).isActive = true
        let titleLabel = CustomLabel(localisationKey: localizationKey)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        // Add custom label to the button
        addSubview(titleLabel)
        // Position the label within the button
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

