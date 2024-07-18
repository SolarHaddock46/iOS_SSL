import UIKit

enum ContentElement {
    case label(text: String)
    case heading(text: String)
    case subtext(text: String)
    case textField(name: String, placeholder: String, isSecure: Bool)
    case checkbox(name: String, label: String, isChecked: Bool)
    case primaryButton(title: String, action: Selector)
    case secondaryButton(title: String, action: Selector)
    case customView(UIView)
    case spacing(height: CGFloat)
}

class TemplateViewController: UIViewController {
    
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
    
    let contentView: UIStackView = {
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
    
    let navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()
    
    let horizontalPadding: CGFloat = 16
    let verticalPadding: CGFloat = 28
    
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
            contentView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16)
        ])
    }
    
    func setupContentView(withElements elements: [ContentElement]) {
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
            case .secondaryButton(let title, let action):
                view = createSecondaryButton(title: title, action: action)
            case .customView(let customView):
                view = customView
            case .checkbox(let name, let label, let isChecked):
                let checkboxView = CheckboxWithLabel(localisationKey: label)
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
        let buttonContainer = PrimaryButtonContainer(localizationKey: title)
        buttonContainer.addTarget(self, action: action, for: .touchUpInside)
        return buttonContainer
    }
    
    private func createSecondaryButton(title: String, action: Selector) -> SecondaryButtonContainer {
        let buttonContainer = SecondaryButtonContainer(localizationKey: title)
        buttonContainer.addTarget(self, action: action, for: .touchUpInside)
        return buttonContainer
    }
    
    func getTextFieldValue(forName name: String) -> String? {
        return textFieldsByName[name]?.enteredText
    }
    
    func getCheckboxState(forName name: String) -> Bool? {
        return checkboxesByName[name]?.isChecked
    }
}
