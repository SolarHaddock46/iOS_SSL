import UIKit

class LoginViewController: TemplateViewController, LoginViewControllerProtocol {

    var interactor: LoginInteractorProtocol?
    private var sslDialogPresenter: LoginDialog?

    private var emailTextFieldContainer: UserInfoTextFieldContainer?
    private var passwordTextFieldContainer: UserInfoTextFieldContainer?

    private var emailTextField: UserInfoTextField?
    private var passwordTextField: UserInfoTextField?

    init() {
        super.init(nibName: nil, bundle: nil)
        sslDialogPresenter = LoginDialog(viewController: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayoutUsingEnum()
    }

    private func setupLayoutUsingEnum() {
        let emailContainer = UserInfoTextFieldContainer(placeholder: NSLocalizedString("Email", comment: "Email placeholder"), isSecure: false)
        let passwordContainer = UserInfoTextFieldContainer(placeholder: NSLocalizedString("Password", comment: "Password placeholder"), isSecure: true)

        self.emailTextFieldContainer = emailContainer
        self.passwordTextFieldContainer = passwordContainer

        self.emailTextField = emailContainer.getTextField()
        self.passwordTextField = passwordContainer.getTextField()

        let elements: [ContentElement] = [
            .heading(text: "Log in"),
            .customView(emailContainer),
            .customView(passwordContainer),
            .primaryButton(title: "Sign in", action: #selector(loginButtonTapped)),
            .secondaryButton(title: "Sign up", action: #selector(toRegisterButtonTapped))
        ]

        setupContentView(withElements: elements)
    }

    @objc private func loginButtonTapped() async throws {
        // Check if any of the fields is empty
        guard let email = emailTextField?.enteredText, !email.isEmpty,
              let password = passwordTextField?.enteredText, !password.isEmpty else {
            emailTextField?.isValid = !(emailTextField?.enteredText?.isEmpty ?? true)
            passwordTextField?.isValid = !(passwordTextField?.enteredText?.isEmpty ?? true)
            return
        }

        // Validate email and password
        emailTextField?.isValid = SSLValidator.emailIsValid(email: email)
        passwordTextField?.isValid = !password.isEmpty

        // Check if both fields are valid before proceeding
        guard emailTextField?.isValid == true, passwordTextField?.isValid == true else {
            return
        }

        try await interactor?.login(email: email, password: password)
    }

    @objc private func toRegisterButtonTapped() {
        let registerScene = RegisterAssembly.build()
        navigationController?.pushViewController(registerScene, animated: true)
    }

    func showAlert(title: String, message: String) {
        sslDialogPresenter?.showAlert(title: title, message: message)
    }

    func displayLoginSuccess(message: String) {
        showAlert(title: "Success", message: message)
    }

    func displayLoginError(message: String) {
        showAlert(title: "Error", message: message)
    }
}
