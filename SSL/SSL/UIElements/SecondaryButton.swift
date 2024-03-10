import UIKit

final class SecondaryButton: UIButton {

    init(localizationKey: String) {
        super.init(frame: .zero)
        setup(localizationKey: localizationKey)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setup(localizationKey: String) {
        backgroundColor = .clear
        heightAnchor.constraint(equalToConstant: 48).isActive = true
        let titleLabel = CustomLabel(localisationKey: localizationKey, color: UIColor(red: 63/255, green: 162/255, blue: 254/255, alpha: 1.0))
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
