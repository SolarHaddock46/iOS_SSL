import UIKit

class LoginViewController: UIViewController, PresenterToViewProtocol {
    var presenter: ViewToPresenterProtocol?
    
    private lazy var testView: UIStackView = {
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
    private lazy var testSecButton = SecondaryButton(localizationKey: "Sign up")

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        testView.addArrangedSubview(emailTextField)
        testView.addArrangedSubview(passwordTextField)
        testView.addArrangedSubview(loginButton)
        testView.addArrangedSubview(testSecButton)
        testView.addArrangedSubview(activityIndicator)

        view.addSubview(navBar)
        view.addSubview(testView)
        testView.translatesAutoresizingMaskIntoConstraints = false
        navBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            testView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            testView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            testView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])

        loginButton.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
    }

    @objc func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.enteredText,
              let password = passwordTextField.enteredText else { return }
        emailTextField.isValid = emailIsValid(email: email)
//        passwordTextField.isValid = passwordIsValid(password: password)

        guard emailIsValid(email: email) else { return }

        presenter?.startLogin(email: email, password: password)
        showLoading()
    }
    
    private func emailIsValid(email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        guard email.range(of: pattern, options: .regularExpression) != nil else {
            return false
        }
        return true
    }
    
//    private func passwordIsValid(password: String) -> Bool {
//        let pattern = "^(?=.*[A-Z].*[A-Z])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$"
//        guard password.range(of: pattern, options: .regularExpression) != nil else {
//            return false
//        }
//        return true
//    }

    func showLoading() {
        activityIndicator.startAnimating()
        loginButton.isEnabled = false
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
        loginButton.isEnabled = true
    }

    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            self.hideLoading()
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func showLoginSuccess() {
        hideLoading()
        showAlert(title: "Success", message: "Login successful.")
    }

    func showLoginError(error: Error) {
        hideLoading()

//        if let nsError = error as? NSError,
//           let data = nsError.userInfo["responseData"] as? Data,
//           let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//           let detail = json["detail"] as? String {
//            showAlert(title: "Ошибка", message: detail)
//            return
//        }
    }

}
