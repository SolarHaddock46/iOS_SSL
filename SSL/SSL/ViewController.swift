import UIKit

class ViewController: UIViewController {
    
    private lazy var testView: UIStackView = {
        let view = UIStackView()
        view.spacing = 48
        view.axis = .vertical
        return view
    }()
    
    private lazy var testLabel = CustomLabel(localisationKey: "Log in")
    
    private lazy var textField = UserInfoTextField(placeholder: NSLocalizedString("Password", comment: "a"), isSecure: true)
    
    private lazy var emailField = UserInfoTextField(placeholder: NSLocalizedString("Email", comment: "a"), isSecure: false)
    
    private lazy var testButton = PrimaryButton(localizationKey: "Sign up")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        testView.addArrangedSubview(testLabel)
        testView.addArrangedSubview(textField)
        testView.addArrangedSubview(emailField)
        testView.addArrangedSubview(testButton)
        
        view.addSubview(testView)
        testView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            testView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            testView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
}
