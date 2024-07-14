import UIKit

enum ContentElement {
    case label(text: String, topMargin: CGFloat)
    case heading(text: String, topMargin: CGFloat)
    case textField(name: String, placeholder: String, isSecure: Bool, topMargin: CGFloat)
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
            titleLabel.widthAnchor.constraint(equalToConstant: 256),
            titleLabel.heightAnchor.constraint(equalToConstant: 52),
            titleLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor, constant: -0.5),
            titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 131)
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
            contentView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            contentView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16)
        ])
    }
    
    func setupContentView(withElements elements: [ContentElement], margin: CGFloat = 16) {
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
            case .textField(let name, let placeholder, let isSecure, let margin):
                let textField = UserInfoTextField(placeholder: placeholder, isSecure: isSecure)
                textFieldsByName[name] = textField
                view = textField
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
            }
            
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            if let previous = previousView {
                NSLayoutConstraint.activate([
                    view.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: topMargin)
                ])
            } else {
                NSLayoutConstraint.activate([
                    view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin)
                ])
            }
            
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
                view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin)
            ])
            
            previousView = view
        }
        
        if let lastView = previousView {
            NSLayoutConstraint.activate([
                lastView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin)
            ])
        }
    }
    
    private func createLabel(withText text: String) -> UILabel {
        return SSLLabel(localizationKey: text, isHeading: false)
    }
    
    private func createHeading(withText text: String) -> UILabel {
        return SSLLabel(localizationKey: text, isHeading: true)
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
}
