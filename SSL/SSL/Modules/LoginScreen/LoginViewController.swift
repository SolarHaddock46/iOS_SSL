import Foundation
import UIKit

protocol LoginViewControllerProtocol: AnyObject {
    var interactor: LoginInteractorProtocol? { get set }
    func showAlert(title: String, message: String)
}

class LoginViewController: UIViewController, LoginViewControllerProtocol {
    
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
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        view.backgroundColor = .white

        loginStackView.addArrangedSubview(emailTextField)
        loginStackView.addArrangedSubview(passwordTextField)
        loginStackView.addArrangedSubview(loginButton)
        loginStackView.addArrangedSubview(toRegisterButton)

        view.addSubview(loginStackView)
        
        loginStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            loginStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            loginStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])

        loginButton.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
        toRegisterButton.addTarget(self, action: #selector(toRegisterButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTitle()
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
        
        Task {
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
    
    // я хз почему, но в LoginPresenter напрямую использовать SSLDialogPresenter не получается, поэтому пока оставил функцию как костыль
    func showAlert(title: String, message: String) {
        sslDialogPresenter?.showAlert(title: title, message: message)
    }
}
