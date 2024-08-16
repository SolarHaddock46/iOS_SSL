import UIKit

enum AuthContentElement {
    case label(text: String)
    case heading(text: String)
    case subtext(text: String)
    case textField(name: String, placeholder: String, isSecure: Bool)
    case checkbox(name: String, label: String, isChecked: Bool)
    case primaryButton(title: String, action: Selector)
    case secondaryButton(title: SecondaryButtonTitle, action: Selector, alignment: SecondaryButtonAlignment = .center)
    case customView(UIView)
    case spacing(height: CGFloat)
}

enum SecondaryButtonAlignment {
    case leading
    case center
    case trailing
}

enum SecondaryButtonTitle {
    case text(String)
    case attributedText(NSAttributedString)
}

class AuthTemplateViewController: UIViewController {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .templateBackgroundColor
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = UIFont.rubikExtraBold(ofSize: 34)
        
        let attributedText = NSMutableAttributedString(string: "Soft Skills Lab")
        let range = (attributedText.string as NSString).range(of: "Lab")
        attributedText.addAttribute(.foregroundColor, value: UIColor.buttonBackgroundColor, range: range)
        
        label.textAlignment = .center
        label.attributedText = attributedText
        return label
    }()
    
    private let contentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 16
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.shadowOpacity = 0.1
        stackView.layer.shadowOffset = CGSize(width: 0, height: 2)
        stackView.layer.shadowRadius = 4
        return stackView
    }()
    
    private let navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()
    
    private let horizontalPadding: CGFloat = 16
    private let verticalPadding: CGFloat = 28
    
    var textFieldsByName: [String: UserInfoTextField] = [:]
    var checkboxesByName: [String: CheckboxWithLabel] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        backgroundView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
        ])
        
        backgroundView.addSubview(navigationBar)
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor)
        ])
        
        backgroundView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            contentView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            contentView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16)
        ])
    }
    
    func setupContentView(withElements elements: [AuthContentElement]) {
        elements.forEach { element in
            let view: UIView
            
            switch element {
            case .label(let text):
                view = createLabel(withText: text)
            case .heading(let text):
                view = createHeading(withText: text)
            case .subtext(let text):
                view = createSubtext(withText: text)
            case .textField(let name, let placeholder, let isSecure):
                let textFieldContainer = UserInfoTextFieldContainer(placeholder: placeholder, isSecure: isSecure)
                textFieldsByName[name] = textFieldContainer.textField
                view = textFieldContainer
            case .primaryButton(let title, let action):
                view = createPrimaryButton(title: title, action: action)
            case .secondaryButton(let title, let action, let alignment):
                view = createSecondaryButton(title: title, action: action, alignment: alignment)
            case .customView(let customView):
                view = customView
            case .checkbox(let name, let label, let isChecked):
                let checkboxView = CheckboxWithLabel(localizationKey: label)
                checkboxView.isChecked = isChecked
                checkboxesByName[name] = checkboxView
                view = checkboxView
            case .spacing(let height):
                let spacerView = UIView()
                spacerView.heightAnchor.constraint(equalToConstant: height).isActive = true
                view = spacerView
            }
            
            contentView.addArrangedSubview(view)
        }
        
        contentView.layoutMargins = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        contentView.isLayoutMarginsRelativeArrangement = true
    }
    
    private func createLabel(withText text: String) -> UILabel {
        return SSLLabel(localizationKey: text, isHeading: false)
    }
    
    private func createHeading(withText text: String) -> UILabel {
        return SSLLabel(localizationKey: text, isHeading: true)
    }
    
    private func createSubtext(withText text: String) -> UILabel {
        return SSLLabel(localizationKey: text, isSubtext: true)
    }
    
    private func createPrimaryButton(title: String, action: Selector) -> PrimaryButtonContainer {
        let buttonContainer = PrimaryButtonContainer(id: "", localizationKey: title)
        buttonContainer.addTarget(self, action: action, for: .touchUpInside)
        return buttonContainer
    }
    
    private func createSecondaryButton(title: SecondaryButtonTitle, action: Selector, alignment: SecondaryButtonAlignment) -> UIView {
        let buttonContainer: SecondaryButtonContainer
        
        switch title {
        case .text(let text):
            buttonContainer = SecondaryButtonContainer(localizationKey: text)
        case .attributedText(let attributedText):
            buttonContainer = SecondaryButtonContainer(attributedTitle: attributedText)
        }
        
        buttonContainer.addTarget(self, action: action, for: .touchUpInside)
        
        let containerView = UIView()
        containerView.addSubview(buttonContainer)
        
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        
        switch alignment {
        case .leading:
            NSLayoutConstraint.activate([
                buttonContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                buttonContainer.topAnchor.constraint(equalTo: containerView.topAnchor),
                buttonContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        case .center:
            NSLayoutConstraint.activate([
                buttonContainer.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                buttonContainer.topAnchor.constraint(equalTo: containerView.topAnchor),
                buttonContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        case .trailing:
            NSLayoutConstraint.activate([
                buttonContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                buttonContainer.topAnchor.constraint(equalTo: containerView.topAnchor),
                buttonContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        }
        
        return containerView
    }
    
    func addCloseButton() {
        let closeButton = createCloseButton()
        contentView.addSubview(closeButton)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func createCloseButton() -> UIButton {
        let button = PrimaryButton(localizationKey: "✕", color: .closeButtonbackgroundColor, textColor: .mainTextColor)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }
    
    @objc private func closeButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func getTextFieldValue(forName name: String) -> String? {
        return textFieldsByName[name]?.text
    }
    
    func getCheckboxState(forName name: String) -> Bool? {
        return checkboxesByName[name]?.isChecked
    }
}
