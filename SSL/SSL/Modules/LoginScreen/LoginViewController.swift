import UIKit

class LoginViewController: TemplateViewController, LoginViewControllerProtocol {
    var interactor: LoginInteractorProtocol?
    var router: SSLRoutingLogic
    private var dialog: LoginDialog?
    
    private lazy var elements: [ContentElement] = {
        return [
            .heading(text: "Log in", topMargin: 0),
            .textField(name: "email", placeholder: NSLocalizedString("Email", comment: "Email placeholder"), isSecure: false, topMargin: 44),
            .textField(name: "password", placeholder: NSLocalizedString("Password", comment: "Password placeholder"), isSecure: true, topMargin: 18),
            .secondaryButton(title: "Forgot your password?", action: #selector(forgotPasswordButtonTapped(_:)), topMargin: 11),
            .primaryButton(title: "Sign in", action: #selector(loginButtonTapped(_:)), topMargin: 11),
            .secondaryButton(title: "Sign up", action: #selector(toRegisterButtonTapped(_:)), topMargin: 8)
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
    
    private func setupLayout() {
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
            } catch let error as NetworkError {
                dialog?.showAlert(title: "Error", message: error.localizedDescription)
            } catch {
                dialog?.showAlert(title: "Error", message: error.localizedDescription)
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
