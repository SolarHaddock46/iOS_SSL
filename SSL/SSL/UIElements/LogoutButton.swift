import UIKit
import Foundation

class LogoutButton: UIButton {

    let title = SSLLabel(localizationKey: "", color: .logoutButtonColor, size: 17, isMedium: true)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    private func setupButton() {
        backgroundColor = .templateBackgroundColor

        title.textAlignment = .center
        title.numberOfLines = 0

        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])

        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.logoutButtonColor.cgColor

        layer.shadowColor = UIColor.logoutButtonColor.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
    }

    func setCardText(_ text: String) {
        title.text = text
    }
}

