import UIKit

protocol LoginViewControllerProtocol: AnyObject {
    var interactor: LoginInteractorProtocol? { get set }
    func showAlert(title: String, message: String)
}

class LoginViewController: TemplateViewController, LoginViewControllerProtocol {
    
    var interactor: LoginInteractorProtocol?
    private var sslDialogPresenter: RegisterDialog?
    
    private lazy var loginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 48
        stackView.axis = .vertical
        return stackView
    }()
    
    private var emailTextField = UserInfoTextField(placeholder: NSLocalizedString("Email", comment: "Email placeholder"), isSecure: false)
    private lazy var passwordTextField = UserInfoTextField(placeholder: NSLocalizedString("Password", comment: "Password placeholder"), isSecure: true)
    private var loginButton = PrimaryButton(localizationKey: "Sign in")
    private var toRegisterButton = SecondaryButton(localizationKey: "Sign up")
    
    init() {
        super.init(nibName: nil, bundle: nil)
        sslDialogPresenter = RegisterDialog(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        updateTitle()
    }
    
    private func setupLayout() {
        loginStackView.addArrangedSubview(emailTextField)
        loginStackView.addArrangedSubview(passwordTextField)
        loginStackView.addArrangedSubview(loginButton)
        loginStackView.addArrangedSubview(toRegisterButton)
        
        addContentSubview(loginStackView)
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
        toRegisterButton.addTarget(self, action: #selector(toRegisterButtonTapped(_:)), for: .touchUpInside)
    }
    
    func updateTitle(with title: String? = NSLocalizedString("Log in", comment: "")) {
        self.title = title
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    @objc func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.enteredText,
              let password = passwordTextField.enteredText else { return }
        emailTextField.isValid = SSLValidator.emailIsValid(email: email)
        passwordTextField.isValid = passwordTextField.enteredText != ""
        
        guard emailTextField.isValid && passwordTextField.isValid else { return }
        
        Task(priority: .high) {
            do {
                try await interactor?.login(email: email, password: password)
            } catch let error as NetworkError {
                sslDialogPresenter?.showAlert(title: "Error", message: error.localizedDescription)
            } catch {
                sslDialogPresenter?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @objc func toRegisterButtonTapped(_ sender: UIButton) {
        let registerScene = RegisterBuilder.build()
        navigationController?.pushViewController(registerScene, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        sslDialogPresenter?.showAlert(title: title, message: message)
    }
}
