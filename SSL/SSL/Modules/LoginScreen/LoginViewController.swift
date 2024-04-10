import UIKit

class LoginViewController: UIViewController, LoginPresenterToViewProtocol {
    var presenter: LoginViewToPresenterProtocol?
    
    private lazy var loginView: UIStackView = {
        let view = UIStackView()
        view.spacing = 48
        view.axis = .vertical
        return view
    }()
    
    private lazy var navBar: UINavigationBar = {
        let navBar = UINavigationBar()
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .gray
        navBar.standardAppearance = appearance
        navBar.prefersLargeTitles = true
        
        let item = UINavigationItem()
        item.title = {
            return NSLocalizedString("Log in", comment: "comment")
        }()
        navBar.setItems([item], animated: true)
        return navBar
    }()

    private lazy var emailTextField = UserInfoTextField(placeholder: NSLocalizedString("Email", comment: "a"), isSecure: false)
    private lazy var passwordTextField = UserInfoTextField(placeholder: NSLocalizedString("Password", comment: "a"), isSecure: true)
    
    private lazy var loginButton = PrimaryButton(localizationKey: "Sign in")
    private lazy var toRegisterButton = SecondaryButton(localizationKey: "Sign up")

//    private lazy var activityIndicator: UIActivityIndicatorView = {
//        let indicator = UIActivityIndicatorView(style: .medium)
//        indicator.hidesWhenStopped = true
//        return indicator
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        loginView.addArrangedSubview(emailTextField)
        loginView.addArrangedSubview(passwordTextField)
        loginView.addArrangedSubview(loginButton)
        loginView.addArrangedSubview(toRegisterButton)
//        loginView.addArrangedSubview(activityIndicator)

        view.addSubview(navBar)
        view.addSubview(loginView)
        loginView.translatesAutoresizingMaskIntoConstraints = false
        navBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            loginView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])

        loginButton.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
        toRegisterButton.addTarget(self, action: #selector(toRegisterButtonTapped(_:)), for: .touchUpInside)
    }

    @objc func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.enteredText,
              let password = passwordTextField.enteredText else { return }
        emailTextField.isValid = emailIsValid(email: email)

        guard emailIsValid(email: email) else { return }

        Task {
            do {
                try await presenter?.startLogin(email: email, password: password)
//                showLoading()
            } catch {
                if let networkError = error as? NetworkError {
                    showAlert(title: "Error", message: networkError.localizedDescription)
                } else {
                    showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    @objc func toRegisterButtonTapped(_ sender: UIButton) {
        navigationController?.pushViewController(RegisterFirstViewController(), animated: true)
    }
    
    private func emailIsValid(email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        guard email.range(of: pattern, options: .regularExpression) != nil else {
            return false
        }
        return true
    }

//    func showLoading() {
//        activityIndicator.startAnimating()
//        loginButton.isEnabled = false
//    }
//
//    func hideLoading() {
//        DispatchQueue.main.async {
//            self.activityIndicator.stopAnimating()
//            self.loginButton.isEnabled = true
//        }
//    }

    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
//            self.hideLoading()
        }
    }

//    func showLoginSuccess() {
////        hideLoading()
//        showAlert(title: "Success", message: "Login successful.")
//    }
//
//    func showLoginError(error: Error) {
//        hideLoading()
//
////        if let nsError = error as? NSError,
////           let data = nsError.userInfo["responseData"] as? Data,
////           let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
////           let detail = json["detail"] as? String {
////            showAlert(title: "Ошибка", message: detail)
////            return
////        }
//    }

}
