import Foundation
import UIKit

class RegisterSecondViewController: UIViewController {
    var presenter: RegisterViewToPresenterProtocol?
    
    private lazy var mainView: UIStackView = {
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
        item.title = NSLocalizedString("Register an account", comment: "")
        navBar.setItems([item], animated: true)
        return navBar
    }()
    
    private lazy var emailTextField = UserInfoTextField(placeholder: NSLocalizedString("Email", comment: ""), isSecure: false)
    private lazy var telegramTextField = UserInfoTextField(placeholder: NSLocalizedString("Telegram", comment: ""), isSecure: false)
    private lazy var password1TextField = UserInfoTextField(placeholder: NSLocalizedString("Password", comment: ""), isSecure: true)
    private lazy var password2TextField = UserInfoTextField(placeholder: NSLocalizedString("Repeat password", comment: ""), isSecure: true)
    
    private lazy var registerButton = PrimaryButton(localizationKey: "Register")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        mainView.addArrangedSubview(emailTextField)
        mainView.addArrangedSubview(telegramTextField)
        mainView.addArrangedSubview(password1TextField)
        mainView.addArrangedSubview(password2TextField)
        mainView.addArrangedSubview(registerButton)
        
        view.addSubview(navBar)
        view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 16),
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            navBar.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func isFormValid() -> Bool {
        emailTextField.isValid = !emailTextField.isTextEmpty
        telegramTextField.isValid = !telegramTextField.isTextEmpty
        password1TextField.isValid = !password1TextField.isTextEmpty
        password2TextField.isValid = !password2TextField.isTextEmpty
        
        if password1TextField.enteredText != password2TextField.enteredText {
            password2TextField.isValid = false
        }
        
        return emailTextField.isValid && telegramTextField.isValid && password1TextField.isValid && password2TextField.isValid
    }
    
    @objc func registerButtonTapped(_ sender: UIButton) {
        if isFormValid() {
            let email = emailTextField.enteredText
            let telegram = telegramTextField.enteredText
            let password1 = password1TextField.enteredText
            let password2 = password2TextField.enteredText
            navigationController?.pushViewController(EmailVerificationViewController(), animated: true)
//            presenter?.startRegister(email: email, telegram: telegram, password1: password1, password2: password2) { [weak self] error in
//                if let error = error {
//                    self?.showAlert(title: "Error", message: "An error occurred during registration: \(error.localizedDescription)")
//                } else {
//                    self?.showAlert(title: "Success", message: "Registration successful")
//                }
            }
        }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
