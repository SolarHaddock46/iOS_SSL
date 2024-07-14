import UIKit

class LoginViewController: TemplateViewController, LoginViewControllerProtocol {
    var interactor: LoginInteractorProtocol?
    private var dialog: LoginDialog?
    
    private lazy var elements: [ContentElement] = {
        return [
            .heading(text: "Log in", bottomMargin: 44),
            .textField(name: "email", placeholder: NSLocalizedString("Email", comment: "Email placeholder"), isSecure: false, bottomMargin: 18),
            .textField(name: "password", placeholder: NSLocalizedString("Password", comment: "Password placeholder"), isSecure: true, bottomMargin: 44),
            .secondaryButton(title: "Forgot your password?", action: #selector(loginButtonTapped(_:)), bottomMargin: 10),
            .primaryButton(title: "Sign in", action: #selector(loginButtonTapped(_:)), bottomMargin: 8),
            .secondaryButton(title: "Sign up", action: #selector(toRegisterButtonTapped(_:)), bottomMargin: 0)
        ]
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        dialog = LoginDialog(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
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
    
    @objc func toRegisterButtonTapped(_ sender: UIButton) {
        let registerScene = RegisterAssembly.build()
        navigationController?.pushViewController(registerScene, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        dialog?.showAlert(title: title, message: message)
    }
}
