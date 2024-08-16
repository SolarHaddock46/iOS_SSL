import UIKit

class ProfileContentView: UIView {
    private let stackView: UIStackView
    private let containsLogoutButton: Bool

    init(elements: [ProfileCardContentElement]) {
        self.stackView = UIStackView()
        self.stackView.axis = .vertical
        self.containsLogoutButton = elements.contains { $0.isLogoutButton }

        super.init(frame: .zero)
        setupViews(elements: elements)
        setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews(elements: [ProfileCardContentElement]) {
        if containsLogoutButton {
            setupForLogoutButton(elements: elements)
        } else {
            setupForRegularElements(elements: elements)
        }
    }

    private func setupForLogoutButton(elements: [ProfileCardContentElement]) {
        for element in elements {
            if case .logoutButton = element {
                let view = createView(for: element)
                addSubview(view)
                setupFullConstraints(for: view)
                break
            }
        }
    }

    private func setupForRegularElements(elements: [ProfileCardContentElement]) {
        for element in elements {
            let view = createView(for: element)
            stackView.addArrangedSubview(view)
        }

        addSubview(stackView)
        setupStackViewConstraints()

        if elements.contains(where: { $0.isNameLabel }) {
            addEditButtonToNameCard()
        }
    }

    private func setupAppearance() {
        backgroundColor = containsLogoutButton ? .templateBackgroundColor : .white
        layer.cornerRadius = 16
        configureShadowAndBorder()
    }

    private func configureShadowAndBorder() {
        layer.borderColor = containsLogoutButton ? UIColor.logoutButtonColor.cgColor : nil
        layer.borderWidth = containsLogoutButton ? 2 : 0
        layer.shadowColor = containsLogoutButton ? UIColor.logoutButtonColor.cgColor : UIColor.black.cgColor
        layer.shadowOpacity = containsLogoutButton ? 0.5 : 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }

    private func createView(for element: ProfileCardContentElement) -> UIView {
        switch element {
        case .nameLabel(let text):
            return createNameLabel(withText: text)
        case .subtext(let text):
            return createSubtext(withText: text)
        case .label(let text):
            return createLabel(withText: text)
        case .heading(let text):
            return createHeading(withText: text)
        case .dataButton(let id, let text, let isSecure):
            return createDataButton(withId: id, text: text, isSecure: isSecure)
        case .customView(let customView):
            return customView
        case .spacing(let height):
            return createSpacerView(height: height)
        case .textField(let id, let placeholder, let isSecure):
            return createTextField(withId: id, placeholder: placeholder, isSecure: isSecure)
        case .button(let id, let text):
            return createButton(withId: id, text: text)
        case .logoutButton:
            return createLogoutButton()
        case .secondaryButton(let id, let text):
            return createSecondaryButton(withId: id, text: text)
        case .secondaryButtonWithAttributedTitle(let id, let attributedTitle):
            return createSecondaryButton(withId: id, attributedTitle: attributedTitle)
        case .profilePicView(let showDescriptionLabel):
            return createProfilePicView(showDescriptionLabel: showDescriptionLabel)
        }
    }

    private func createProfilePicView(showDescriptionLabel: Bool) -> UIView {
        let profilePicView = ProfilePicView(frame: .zero, showDescriptionLabel: showDescriptionLabel)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profilePicTapped))
        profilePicView.addGestureRecognizer(tapGestureRecognizer)
        return profilePicView
    }

    private func createNameLabel(withText text: String) -> UILabel {
        let label = SSLLabel(localizationKey: text, isHeading: true)
        label.textAlignment = .center
        return label
    }

    private func createSubtext(withText text: String) -> UILabel {
        return SSLLabel(localizationKey: text, isSubtext: true)
    }

    private func createLabel(withText text: String) -> UILabel {
        let label = SSLLabel(localizationKey: text)
        label.textAlignment = .left
        return label
    }

    private func createHeading(withText text: String) -> UILabel {
        return SSLLabel(localizationKey: text, isHeading: true)
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

    private func createLogoutButton() -> LogoutButton {
        let logoutButton = LogoutButton(frame: .zero)
        logoutButton.setCardText("Log Out")
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped(_:)), for: .touchUpInside)
        setupLogoutButtonConstraint(logoutButton)
        return logoutButton
    }

    private func setupLogoutButtonConstraint(_ button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([button.heightAnchor.constraint(equalToConstant: 46)])
    }

    private func createSecondaryButton(withId id: String, text: String) -> SecondaryButtonView {
        let buttonView = SecondaryButtonView(id: id, text: text)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(secondaryButtonTapped(_:)))
        buttonView.addGestureRecognizer(tapRecognizer)
        return buttonView
    }

    private func createSecondaryButton(withId id: String, attributedTitle: NSAttributedString) -> SecondaryButtonView {
        let buttonView = SecondaryButtonView(id: id, attributedText: attributedTitle)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(secondaryButtonTapped(_:)))
        buttonView.addGestureRecognizer(tapRecognizer)
        return buttonView
    }

    private func createSpacerView(height: CGFloat) -> UIView {
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.heightAnchor.constraint(equalToConstant: height).isActive = true
        return spacerView
    }

    private func setupStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
    }

    private func setupFullConstraints(for view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
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
            button.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 24),
            button.widthAnchor.constraint(equalToConstant: 24)
        ])
    }

    @objc private func profilePicTapped() {
        NotificationCenter.default.post(name: .profilePicTapped, object: nil)
    }

    @objc private func buttonTapped(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: .buttonTapped, object: sender.view)
    }

    @objc private func logoutButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: .logoutButtonTapped, object: nil)
    }

    @objc private func secondaryButtonTapped(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: .secondaryButtonTapped, object: sender.view)
    }

    @objc private func editButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: .editButtonTapped, object: nil)
    }
}
