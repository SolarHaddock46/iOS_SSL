import UIKit
import Photos

final class RegisterFirstViewController: TemplateViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let router: SSLRoutingLogic
    
    private var dialog: RegisterFirstDialog?
    private var profilePicPicker: ProfilePicView
    private var profilePicData: Data?
    private var elements: [ContentElement] = {
        return [
            .heading(text: "Register an account"),
            .spacing(height: 24),
            .customView(UIView()),
            .spacing(height: 24),
            .textField(name: "Second name", placeholder: NSLocalizedString("Second name", comment: ""), isSecure: false),
            .spacing(height: 18),
            .textField(name: "First name", placeholder: NSLocalizedString("First name", comment: ""), isSecure: false),
            .spacing(height: 18),
            .textField(name: "Father name", placeholder: NSLocalizedString("Father name", comment: ""), isSecure: false),
            .spacing(height: 18),
            .checkbox(name: "hsePass", label: "I need a HSE Pass", isChecked: false),
            .spacing(height: 17),
            .checkbox(name: "conditions", label: "I accept the Terms of use and the Privacy Policy", isChecked: false),
            .spacing(height: 11),
            .primaryButton(title: "Next", action: #selector(nextButtonTapped(_:))),
            .spacing(height: 16),
            .secondaryButton(title: "Log in", action: #selector(toLoginButtonTapped(_:)))
        ]
    }()

    init(router: SSLRoutingLogic) {
        self.router = router
        self.profilePicPicker = ProfilePicView()
        profilePicPicker.descriptionText = NSLocalizedString("Add a profile picture", comment: "")
        super.init(nibName: nil, bundle: nil)
        dialog = RegisterFirstDialog(viewController: self)
        elements[1] = .customView(profilePicPicker)
        profilePicPicker.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView(withElements: elements)
    }
    
    private func isFormValid() -> Bool {
        guard let firstName = getTextFieldValue(forName: "First name"),
              let secondName = getTextFieldValue(forName: "Second name"),
              let fatherName = getTextFieldValue(forName: "Father name") else {
            return false
        }
        
        let firstNameIsValid = SSLValidator.nameIsValid(name: firstName)
        let secondNameIsValid = SSLValidator.nameIsValid(name: secondName)
        let fatherNameIsValid = (fatherName.isEmpty) ? true : SSLValidator.nameIsValid(name: fatherName)
        
        if let firstNameTextField = textFieldsByName["First name"] {
            firstNameTextField.isValid = firstNameIsValid
        }
        
        if let secondNameTextField = textFieldsByName["Second name"] {
            secondNameTextField.isValid = secondNameIsValid
        }
        
        if let fatherNameTextField = textFieldsByName["Father name"] {
            fatherNameTextField.isValid = fatherNameIsValid
        }
        
        let conditionsAccepted: Bool = getCheckboxState(forName: "conditions") ?? false
        
        if !conditionsAccepted {
            dialog?.showAlert(title: "Error", message: "Please accept the Terms of use and the Privacy Policy")
        }
        
        return firstNameIsValid && secondNameIsValid && fatherNameIsValid && conditionsAccepted
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        if isFormValid() {
            let formData = RegisterFirstFormData(
                firstName: getTextFieldValue(forName: "First name") ?? "",
                secondName: getTextFieldValue(forName: "Second name") ?? "",
                fatherName: getTextFieldValue(forName: "Father name") ?? "",
                hsePass: getCheckboxState(forName: "hsePass") ?? false,
                conditionsAccepted: getCheckboxState(forName: "conditions") ?? false,
                profilePicData: profilePicData
            )
            router.navigate(source: self, destination: .registerSecond, data: formData)
        }
    }
    
    @objc func toLoginButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
