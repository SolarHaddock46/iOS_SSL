import Foundation
import UIKit
import Photos

class RegisterFirstViewController: UIViewController, RegisterPresenterToViewProtocol {
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
    
    private var profilePicPicker: ProfilePicView
    private lazy var firstNameTextField = UserInfoTextField(placeholder: NSLocalizedString("First name", comment: ""), isSecure: false)
    private lazy var secondNameTextField = UserInfoTextField(placeholder: NSLocalizedString("Second name", comment: ""), isSecure: false)
    private lazy var fatherNameTextField = UserInfoTextField(placeholder: NSLocalizedString("Father name", comment: ""), isSecure: false)
    
    private lazy var hsePassCheckbox = CheckboxWithLabel(localisationKey: "I need a HSE pass")
    private lazy var acceptConditionsCheckbox = CheckboxWithLabel(localisationKey: "I accept the Terms of use and the Privacy Policy")
    
    private lazy var nextStageButton = PrimaryButton(localizationKey: "Save")
    private lazy var toLoginButton = SecondaryButton(localizationKey: "Log in")
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = nil

        mainView.addArrangedSubview(profilePicPicker)
        mainView.addArrangedSubview(firstNameTextField)
        mainView.addArrangedSubview(secondNameTextField)
        mainView.addArrangedSubview(fatherNameTextField)
        mainView.addArrangedSubview(hsePassCheckbox)
        mainView.addArrangedSubview(acceptConditionsCheckbox)
        mainView.addArrangedSubview(nextStageButton)
        mainView.addArrangedSubview(toLoginButton)

        view.addSubview(navBar)
        view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        navBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 16),
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        nextStageButton.addTarget(self, action: #selector(nextStageButtonTapped(_:)), for: .touchUpInside)
        toLoginButton.addTarget(self, action: #selector(toLoginButtonTapped(_:)), for: .touchUpInside)
    }
    
    init() {
        profilePicPicker = ProfilePicView()
        super.init(nibName: nil, bundle: nil)
        profilePicPicker.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func isFormValid() -> Bool {
        firstNameTextField.isValid = (!firstNameTextField.isTextEmpty)
        secondNameTextField.isValid = (!secondNameTextField.isTextEmpty)
        var conditionsAccepted: Bool = acceptConditionsCheckbox.isChecked
        return firstNameTextField.isValid && secondNameTextField.isValid && conditionsAccepted
    }

    @objc func nextStageButtonTapped(_ sender: UIButton) {
        if isFormValid() {
            navigationController?.pushViewController(RegisterSecondViewController(), animated: true)
        }
    }
    
    @objc func toLoginButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

//    private func emailIsValid(email: String) -> Bool {
//        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        return email.range(of: pattern, options: .regularExpression) != nil
//    }

    func showLoading() {
        activityIndicator.startAnimating()
        toLoginButton.isEnabled = false
    }

    func hideLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.toLoginButton.isEnabled = true
        }
    }

    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.hideLoading()
        }
    }

//    func showLoginSuccess() {
//        hideLoading()
//        showAlert(title: "Success", message: "Login successful.")
//    }
//
//    func showLoginError(error: Error) {
//        hideLoading()
//        // Handle login error
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let secondVC = segue.destination as? RegisterSecondViewController {
//            secondVC.receivedData = (firstNameTextField.text ?? "", secondNameTextField.text ?? "", fatherNameTextField.text ?? "", needHsePass.isChecked)
//        }
//    }

}

extension RegisterFirstViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        profilePicPicker.avatar = image
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension RegisterFirstViewController: ProfilePicViewDelegate {

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


