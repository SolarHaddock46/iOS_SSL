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
    private var profilePicData: Data?

    private lazy var mainStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 48
        view.axis = .vertical
        return view
    }()
    
    private var profilePicPicker: ProfilePicView
    private lazy var secondNameTextField = UserInfoTextField(placeholder: NSLocalizedString("Second name", comment: ""), isSecure: false)
    private lazy var firstNameTextField = UserInfoTextField(placeholder: NSLocalizedString("First name", comment: ""), isSecure: false)
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
        setupLayout()
        updateTitle()
    }

    func updateTitle(with title: String? = NSLocalizedString("Register an account", comment: "")) {
        self.title = title
        self.navigationController?.navigationBar.layoutIfNeeded()
    }

        
    private func setupLayout() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = nil
        setupFirstStageUI()
        
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        nextStageButton.addTarget(self, action: #selector(nextStageButtonTapped(_:)), for: .touchUpInside)
                registerButton.addTarget(self, action: #selector(registerButtonTapped(_:)), for: .touchUpInside)
                toLoginButton.addTarget(self, action: #selector(toLoginButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func setupFirstStageUI() {
        mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        mainStackView.addArrangedSubview(profilePicPicker)
        mainStackView.addArrangedSubview(secondNameTextField)
        mainStackView.addArrangedSubview(firstNameTextField)
        mainStackView.addArrangedSubview(fatherNameTextField)
        mainStackView.addArrangedSubview(hsePassCheckbox)
        mainStackView.addArrangedSubview(acceptConditionsCheckbox)
        mainStackView.addArrangedSubview(nextStageButton)
        mainStackView.addArrangedSubview(toLoginButton)
        mainStackView.addArrangedSubview(activityIndicator)
    }
    
    private func setupSecondStageUI() {
        mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        mainStackView.addArrangedSubview(emailTextField)
        mainStackView.addArrangedSubview(telegramTextField)
        mainStackView.addArrangedSubview(password1TextField)
        mainStackView.addArrangedSubview(password2TextField)
        mainStackView.addArrangedSubview(registerButton)
        mainStackView.addArrangedSubview(activityIndicator)
    }
    
    private func isFirstStageFormValid() -> Bool {
        let namePattern = "^[a-zA-ZА-Яа-я\\s]{1,150}$"
                
        firstNameTextField.isValid = (!firstNameTextField.isTextEmpty && (firstNameTextField.enteredText?.range(of: namePattern, options: .regularExpression) != nil))
        secondNameTextField.isValid = (!secondNameTextField.isTextEmpty && (secondNameTextField.enteredText?.range(of: namePattern, options: .regularExpression) != nil))
        fatherNameTextField.isValid = (fatherNameTextField.isTextEmpty || (fatherNameTextField.enteredText?.range(of: namePattern, options: .regularExpression) != nil))
        
        let conditionsAccepted: Bool = acceptConditionsCheckbox.isChecked
        return firstNameTextField.isValid && secondNameTextField.isValid && fatherNameTextField.isValid && conditionsAccepted
    }
    
    private func isSecondStageFormValid() -> Bool {
        let emailPattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$"
        let telegramPattern = "^(?![^@]*@)[a-zA-Z0-9_]{5,100}$"
        
        emailTextField.isValid = (!emailTextField.isTextEmpty && (emailTextField.enteredText?.range(of: emailPattern, options: .regularExpression) != nil))
        telegramTextField.isValid = (!telegramTextField.isTextEmpty && (telegramTextField.enteredText?.range(of: telegramPattern, options: .regularExpression) != nil))
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
                        image: profilePicData,
                        hsePass: hsePass,
                        acceptConditions: acceptConditions
                    )
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        profilePicPicker.avatar = pickedImage
        
        let targetSize = CGSize(width: 1024, height: 1024)
        guard let resizedImage = resizeImage(pickedImage, targetSize: targetSize) else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        profilePicData = resizedImage.jpegData(compressionQuality: 0.8)
        picker.dismiss(animated: true, completion: nil)
    }

    func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return resizedImage
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
