import UIKit

class LoginViewController: TemplateViewController, LoginViewControllerProtocol {
    var interactor: LoginInteractorProtocol?
    var router: SSLRoutingLogic
    private var dialog: LoginDialog?
    
    private let signUpLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = UIFont.onest(ofSize: 14)
        
        let attributedText = NSMutableAttributedString(string: "Don't have an account? Sign up")
        let range = (attributedText.string as NSString).range(of: "Sign up")
        attributedText.addAttribute(.foregroundColor, value: UIColor.buttonBackgroundColor, range: range)
        
        label.textAlignment = .center
        label.attributedText = attributedText
        return label
    }()
    
    private lazy var elements: [ContentElement] = {
        return [
            .heading(text: "Log in"),
            .spacing(height: 44),
            .textField(name: "email", placeholder: NSLocalizedString("Email", comment: "Email placeholder"), isSecure: false),
            .spacing(height: 18),
            .textField(name: "password", placeholder: NSLocalizedString("Password", comment: "Password placeholder"), isSecure: true),
            .spacing(height: 11),
            .secondaryButton(title: .text("Forgot your password?"), action: #selector(forgotPasswordButtonTapped(_:)), alignment: .trailing),
            .spacing(height: 11),
            .primaryButton(title: "Sign in", action: #selector(loginButtonTapped(_:))),
            .spacing(height: 8),
            .secondaryButton(
                title: .attributedText(signUpLabel.attributedText ?? NSAttributedString(string: "")),
                action: #selector(toRegisterButtonTapped(_:)),
                alignment: .center
            )
        ]
    }()
    
    init(router: SSLRoutingLogic) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
        dialog = LoginDialog(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView(withElements: elements)
    }
    
    @objc func loginButtonTapped(_ sender: UIButton) {
        guard let email = getTextFieldValue(forName: "email"),
              let password = getTextFieldValue(forName: "password") else {
            return
        }
        
        let emailTextField = textFieldsByName["email"]
        let passwordTextField = textFieldsByName["password"]
        
        emailTextField?.isValid = SSLValidator.emailIsValid(email: email)
        passwordTextField?.isValid = !password.isEmpty
        
        guard let isEmailValid = emailTextField?.isValid, isEmailValid,
              let isPasswordValid = passwordTextField?.isValid, isPasswordValid else {
            return
        }
        
        Task(priority: .high) {
            do {
                try await interactor?.login(email: email, password: password)
            } catch {
                showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @objc func forgotPasswordButtonTapped(_ sender: UIButton) {
        router.navigate(source: self, destination: .forgotPassword, data: nil)
    }
    
    @objc func toRegisterButtonTapped(_ sender: UIButton) {
        router.navigate(source: self, destination: .registerFirst, data: nil)
    }
    
    func showAlert(title: String, message: String) {
        dialog?.showAlert(title: title, message: message)
    }
}

