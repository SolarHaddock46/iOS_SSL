import UIKit

class UniversalContentView: UIView {
    private let stackView: UIStackView

    init(elements: [ProfileCardContentElement]) {
        stackView = UIStackView()
        stackView.axis = .vertical

        super.init(frame: .zero)
        setupViews(elements: elements)
        setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews(elements: [ProfileCardContentElement]) {
        elements.forEach { element in
            let view = createView(for: element)
            stackView.addArrangedSubview(view)
        }

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        if elements.contains(where: { $0.isNameLabel }) {
            addEditButtonToNameCard()
        }
    }

    private func setupAppearance() {
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }

    private func createView(for element: ProfileCardContentElement) -> UIView {
        switch element {
        case .nameLabel(let text):
            return createNameLabel(withText: text)
        case .dataButton(let id, let text, let isSecure):
            return createDataButton(withId: id, text: text, isSecure: isSecure)
        case .customView(let customView):
            return customView
        case .spacing(let height):
            let spacerView = UIView()
            spacerView.heightAnchor.constraint(equalToConstant: height).isActive = true
            return spacerView
        case .textField(let id, let placeholder, let isSecure):
            return createTextField(withId: id, placeholder: placeholder, isSecure: isSecure)
        case .button(let id, let text):
            return createButton(withId: id, text: text)
        }
    }

    private func createNameLabel(withText text: String) -> SSLLabel {
       let label = SSLLabel(localizationKey: text, isHeading: true)
       label.textAlignment = .center
       return label
   }

    private func createDataButton(withId id: String, text: String, isSecure: Bool) -> UIView {
        let buttonView = DataButtonView(id: id, text: text, isSecure: isSecure)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:)))
        buttonView.addGestureRecognizer(tapRecognizer)
        return buttonView
    }

    private func createTextField(withId id: String, placeholder: String, isSecure: Bool) -> UIView {
        let textFieldContainer = UserInfoTextFieldContainer(placeholder: placeholder, isSecure: isSecure)
        textFieldContainer.accessibilityIdentifier = id
        return textFieldContainer
    }

    private func createButton(withId id: String, text: String) -> UIView {
        let buttonView = PrimaryButtonView(id: id, text: text)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:)))
        buttonView.addGestureRecognizer(tapRecognizer)
        return buttonView
    }

    @objc private func buttonTapped(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: .buttonTapped, object: sender.view)
    }

    private func addEditButtonToNameCard() {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let editIcon = UIImage(systemName: "pencil", withConfiguration: configuration)
        button.setImage(editIcon, for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
        
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 30),
            button.widthAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc private func editButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: .editButtonTapped, object: nil)
    }
}

extension ProfileCardContentElement {
    var isNameLabel: Bool {
        switch self {
        case .nameLabel:
            return true
        default:
            return false
        }
    }
}
