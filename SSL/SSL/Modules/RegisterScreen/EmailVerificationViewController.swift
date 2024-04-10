import Foundation

import Foundation
import UIKit

class EmailVerificationViewController: UIViewController {
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
        item.title = NSLocalizedString("Email verification code", comment: "")
        navBar.setItems([item], animated: true)
        return navBar
    }()
    
    private lazy var instructionLabel = CustomLabel(localisationKey: "Check your email")
    private lazy var codeTextField = UserInfoTextField(placeholder: NSLocalizedString("Email verification code", comment: ""), isSecure: false)
    private lazy var continueButton = PrimaryButton(localizationKey: "Continue")
    private lazy var resendButton = SecondaryButton(localizationKey: "Resend code")
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        mainView.addArrangedSubview(instructionLabel)
        mainView.addArrangedSubview(codeTextField)
        mainView.addArrangedSubview(continueButton)
        mainView.addArrangedSubview(resendButton)
        
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
        
        continueButton.addTarget(self, action: #selector(continueButtonTapped(_:)), for: .touchUpInside)
        resendButton.addTarget(self, action: #selector(resendButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func isFormValid() -> Bool {
        codeTextField.isValid = !codeTextField.isTextEmpty
        return codeTextField.isValid
    }
    
    @objc func continueButtonTapped(_ sender: UIButton) {
        if isFormValid() {
            showAlert(title: "ok", message: "ok")
        }
    }
    
    @objc func resendButtonTapped(_ sender: UIButton) {
        showAlert(title: "ok fine", message: "ig i will send u another one")
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
