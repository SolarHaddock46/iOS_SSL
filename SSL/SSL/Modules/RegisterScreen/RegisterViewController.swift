import UIKit
import Photos

protocol RegisterViewControllerProtocol: AnyObject {
    func showAlert(title: String, message: String)
}

class RegisterViewController: UIViewController, RegisterViewControllerProtocol, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var interactor: RegisterInteractorProtocol?
    
    private var firstName: String = ""
    private var lastName: String = ""
    private var fatherName: String = ""
    private var email: String = ""
    private var telegram: String = ""
    private var password1: String = ""
    private var password2: String = ""
    private var hsePass: Bool = false
    private var acceptConditions: Bool = false

    private lazy var mainView: UIStackView = {
        let view = UIStackView()
        view.spacing = 48
        view.axis = .vertical
        return view
    }()
    
    private lazy var navBar: UINavigationBar = {
        let navBar = UINavigationBar()
        let appearance = UINavigationBarAppearance()
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "Onest-Bold", size: 34)!]
        appearance.backgroundColor = .white
        appearance.shadowColor = .gray
        appearance.largeTitleTextAttributes = attributes
        navBar.standardAppearance = appearance
        navBar.prefersLargeTitles = true
        let item = UINavigationItem()
        item.title = NSLocalizedString("Register an account", comment: "")
        navBar.setItems([item], animated: true)
        return navBar
    }()
    
    private var profilePicPicker: ProfilePicView
    private lazy var firstNameTextField = UserInfoTextField(placeholder: NSLocalizedString("First name", comment: ""), isSecure: false)
    private lazy var secondNameTextField = UserInfoTextField(placeholder: NSLocalizedString("Second name", comment: ""), isSecure: false)
    private lazy var fatherNameTextField = UserInfoTextField(placeholder: NSLocalizedString("Father name", comment: ""), isSecure: false)
    private lazy var emailTextField = UserInfoTextField(placeholder: NSLocalizedString("Email", comment: ""), isSecure: false)
    private lazy var telegramTextField = UserInfoTextField(placeholder: NSLocalizedString("Telegram", comment: ""), isSecure: false)
    private lazy var password1TextField = UserInfoTextField(placeholder: NSLocalizedString("Password", comment: ""), isSecure: true)
    private lazy var password2TextField = UserInfoTextField(placeholder: NSLocalizedString("Repeat password", comment: ""), isSecure: true)
    
    private lazy var hsePassCheckbox = CheckboxWithLabel(localisationKey: "I need a HSE pass")
    private lazy var acceptConditionsCheckbox = CheckboxWithLabel(localisationKey: "I accept the Terms of use and the Privacy Policy")
    
    private lazy var nextStageButton = PrimaryButton(localizationKey: "Next")
    private lazy var registerButton = PrimaryButton(localizationKey: "Register")
    private lazy var toLoginButton = SecondaryButton(localizationKey: "Log in")
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var isFirstStage = true
    
    init() {
        profilePicPicker = ProfilePicView()
        super.init(nibName: nil, bundle: nil)
        profilePicPicker.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = nil
        setupFirstStageUI()
        
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
        
        nextStageButton.addTarget(self, action: #selector(nextStageButtonTapped(_:)), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped(_:)), for: .touchUpInside)
        toLoginButton.addTarget(self, action: #selector(toLoginButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func setupFirstStageUI() {
        mainView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        mainView.addArrangedSubview(profilePicPicker)
        mainView.addArrangedSubview(firstNameTextField)
        mainView.addArrangedSubview(secondNameTextField)
        mainView.addArrangedSubview(fatherNameTextField)
        mainView.addArrangedSubview(hsePassCheckbox)
        mainView.addArrangedSubview(acceptConditionsCheckbox)
        mainView.addArrangedSubview(nextStageButton)
        mainView.addArrangedSubview(toLoginButton)
        mainView.addArrangedSubview(activityIndicator)
    }
    
    private func setupSecondStageUI() {
        mainView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        mainView.addArrangedSubview(emailTextField)
        mainView.addArrangedSubview(telegramTextField)
        mainView.addArrangedSubview(password1TextField)
        mainView.addArrangedSubview(password2TextField)
        mainView.addArrangedSubview(registerButton)
        mainView.addArrangedSubview(activityIndicator)
    }
    
    private func isFirstStageFormValid() -> Bool {
        let namePattern = "^[a-zA-ZА-Яа-я]+$"
        
        firstNameTextField.isValid = (!firstNameTextField.isTextEmpty && (firstNameTextField.enteredText?.range(of: namePattern, options: .regularExpression) != nil))
        secondNameTextField.isValid = (!secondNameTextField.isTextEmpty && (secondNameTextField.enteredText?.range(of: namePattern, options: .regularExpression) != nil))
        fatherNameTextField.isValid = (fatherNameTextField.isTextEmpty || (fatherNameTextField.enteredText?.range(of: namePattern, options: .regularExpression) != nil))
        
        let conditionsAccepted: Bool = acceptConditionsCheckbox.isChecked
        return firstNameTextField.isValid && secondNameTextField.isValid && fatherNameTextField.isValid && conditionsAccepted
    }
    
    private func isSecondStageFormValid() -> Bool {
        emailTextField.isValid = !emailTextField.isTextEmpty
        telegramTextField.isValid = !telegramTextField.isTextEmpty
        password1TextField.isValid = !password1TextField.isTextEmpty
        password2TextField.isValid = !password2TextField.isTextEmpty
        
        if password1TextField.enteredText != password2TextField.enteredText {
            password2TextField.isValid = false
        }
        
        return emailTextField.isValid && telegramTextField.isValid && password1TextField.isValid && password2TextField.isValid
    }
    
    @objc func nextStageButtonTapped(_ sender: UIButton) {
        if isFirstStageFormValid() {
            isFirstStage = false
            firstName = firstNameTextField.enteredText ?? ""
            lastName = secondNameTextField.enteredText ?? ""
            fatherName = fatherNameTextField.enteredText ?? ""
            hsePass = hsePassCheckbox.isChecked
            acceptConditions = acceptConditionsCheckbox.isChecked
            setupSecondStageUI()
        } else {
            showAlert(title: "Error", message: "Please fill in all required fields and accept the terms.")
        }
    }

    @objc func registerButtonTapped(_ sender: UIButton) {
        if isSecondStageFormValid() {
            Task {
                do {
                    try await interactor?.register(
                        firstName: firstName,
                        lastName: lastName,
                        fatherName: fatherName,
                        telegram: telegramTextField.enteredText ?? "",
                        email: emailTextField.enteredText ?? "",
                        password1: password1TextField.enteredText ?? "",
                        password2: password2TextField.enteredText ?? "",
                        image: "null",
                        hsePass: hsePass,
                        acceptConditions: acceptConditions
                    )
                    // navigationController?.pushViewController(EmailVerificationViewController(), animated: true)
                    showAlert(title: "Success", message: firstName)
                } catch {
                    if let networkError = error as? NetworkError {
                        showAlert(title: "Error", message: networkError.localizedDescription)
                    } else {
                        showAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            }
        } else {
            showAlert(title: "Error", message: "Please fill in all required fields and make sure passwords match.")
        }
    }
    
    @objc func toLoginButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension RegisterViewController: ProfilePicViewDelegate {

    func profilePicViewDidTapAvatar() {
        requestPhotoLibraryAccess()
    }

    func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            switch status {
            case .authorized, .limited:
                DispatchQueue.main.async { [weak self] in
                    self?.showImagePicker()
                }
            default:
                break
            }
        }
    }

    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
}
