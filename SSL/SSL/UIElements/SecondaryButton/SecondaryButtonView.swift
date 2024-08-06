import UIKit

final class SecondaryButtonView: UIView {
    let id: String
    let textLabel: UILabel

    init(id: String, text: String) {
        self.id = id
        textLabel = SSLLabel(localizationKey: text)
        textLabel.textColor = .buttonBackgroundColor
        textLabel.textAlignment = .left

        super.init(frame: .zero)

        setupViews()
    }

    init(id: String, attributedText: NSAttributedString) {
        self.id = id
        textLabel = UILabel()
        textLabel.attributedText = attributedText
        textLabel.textAlignment = .left

        super.init(frame: .zero)

        adjustTextLabelAlignment(for: attributedText)
        
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .clear
        layer.cornerRadius = 10
        heightAnchor.constraint(equalToConstant: 46).isActive = true

        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            heightAnchor.constraint(equalTo: textLabel.heightAnchor)
        ])

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:)))
        addGestureRecognizer(tapRecognizer)
    }

    @objc private func buttonTapped(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: .secondaryButtonTapped, object: self)
    }

    private func adjustTextLabelAlignment(for attributedText: NSAttributedString) {
        textLabel.textAlignment = .left

        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.paragraphStyle, in: range, options: []) { (value, _, _) in
            if let paragraphStyle = value as? NSParagraphStyle {
                textLabel.textAlignment = paragraphStyle.alignment
            }
        }
    }
}

