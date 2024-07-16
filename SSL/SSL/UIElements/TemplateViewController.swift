import UIKit

enum ContentElement {
    case label(text: String, topMargin: CGFloat)
    case heading(text: String, topMargin: CGFloat)
    case subtext(text: String, topMargin: CGFloat)
    case textField(name: String, placeholder: String, isSecure: Bool, topMargin: CGFloat)
    case checkbox(name: String, label: String, isChecked: Bool, topMargin: CGFloat)
    case primaryButton(title: String, action: Selector, topMargin: CGFloat)
    case secondaryButton(title: String, action: Selector, topMargin: CGFloat)
    case customView(UIView, topMargin: CGFloat)
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
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    let navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()
    
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
    
    func setupContentView(withElements elements: [ContentElement], horizontalPadding: CGFloat = 16, verticalPadding: CGFloat = 28) {
        var previousView: UIView?
        
        elements.forEach { element in
            let view: UIView
            let topMargin: CGFloat
            
            switch element {
            case .label(let text, let margin):
                view = createLabel(withText: text)
                topMargin = margin
            case .heading(let text, let margin):
                view = createHeading(withText: text)
                topMargin = margin
            case .subtext(let text, let margin):
                view = createSubtext(withText: text)
                topMargin = margin
            case .textField(let name, let placeholder, let isSecure, let margin):
                let textFieldContainer = UserInfoTextFieldContainer(placeholder: placeholder, isSecure: isSecure)
                textFieldsByName[name] = textFieldContainer.textField
                view = textFieldContainer
                topMargin = margin
            case .primaryButton(let title, let action, let margin):
                view = createPrimaryButton(title: title, action: action)
                topMargin = margin
            case .secondaryButton(let title, let action, let margin):
                view = createSecondaryButton(title: title, action: action)
                topMargin = margin
            case .customView(let customView, let margin):
                view = customView
                topMargin = margin
            case .checkbox(let name, let label, let isChecked, let margin):
                let checkboxView = CheckboxWithLabel(localisationKey: label)
                checkboxView.isChecked = isChecked
                checkboxesByName[name] = checkboxView
                view = checkboxView
                topMargin = margin
            }
            
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            if let previous = previousView {
                NSLayoutConstraint.activate([
                    view.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: topMargin)
                ])
            } else {
                NSLayoutConstraint.activate([
                    view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding)
                ])
            }
            
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
                view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding)
            ])
            
            previousView = view
        }
        
        if let lastView = previousView {
            NSLayoutConstraint.activate([
                lastView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding)
            ])
        }
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
