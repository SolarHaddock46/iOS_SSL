import UIKit

enum ContentElement {
    case label(text: String)
    case heading(text: String)
    case textField(placeholder: String, isSecure: Bool)
    case primaryButton(title: String, action: Selector)
    case secondaryButton(title: String, action: Selector)
    case customView(UIView)
}

import UIKit

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

            switch element {
            case .label(let text):
                view = createLabel(withText: text)
            case .heading(let text):
                view = createHeading(withText: text)
            case .textField(let placeholder, let isSecure):
                view = UserInfoTextFieldContainer(placeholder: placeholder, isSecure: isSecure)
            case .primaryButton(let title, let action):
                view = createPrimaryButton(title: title, action: action)
            case .secondaryButton(let title, let action):
                view = createSecondaryButton(title: title, action: action)
            case .customView(let customView):
                view = customView
            }

            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false

            if let previous = previousView {
                NSLayoutConstraint.activate([
                    view.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: margin)
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

    private func createPrimaryButton(title: String, action: Selector) -> PrimaryButton {
        let button = PrimaryButton(localizationKey: title)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func createSecondaryButton(title: String, action: Selector) -> SecondaryButton {
        let button = SecondaryButton(localizationKey: title)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}
