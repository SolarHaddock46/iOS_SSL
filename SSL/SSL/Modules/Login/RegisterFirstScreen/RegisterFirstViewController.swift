import UIKit
import Photos

final class RegisterFirstViewController: AuthTemplateViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let router: SSLRoutingLogic
    private var dialog: RegisterFirstDialog?
    private var profilePicPicker: ProfilePicView
    private var profilePicData: Data?

    private var elements: [AuthContentElement] = {
        return [
            .heading(text: "Register an account"),
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
            .secondaryButton(title: .text("Log in"), action: #selector(toLoginButtonTapped(_:)))
        ]
    }()

    init(router: SSLRoutingLogic) {
        self.router = router
        self.profilePicPicker = ProfilePicView(frame: .zero, showDescriptionLabel: true)
        profilePicPicker.descriptionText = NSLocalizedString("Add a profile picture", comment: "")

        super.init(nibName: nil, bundle: nil)
        
        dialog = RegisterFirstDialog(viewController: self)
        
        elements[2] = .customView(profilePicPicker)
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

        textFieldsByName["First name"]?.isValid = firstNameIsValid
        textFieldsByName["Second name"]?.isValid = secondNameIsValid
        textFieldsByName["Father name"]?.isValid = fatherNameIsValid

        let conditionsAccepted = getCheckboxState(forName: "conditions") ?? false
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

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let targetSize = CGSize(width: 1024, height: 1024)
            let resizedImage = self?.resizeImage(pickedImage, targetSize: targetSize)

            DispatchQueue.main.async {
                self?.profilePicPicker.avatar = resizedImage
                self?.profilePicData = resizedImage?.jpegData(compressionQuality: 0.8)
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }

    func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
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
            DispatchQueue.main.async { [weak self] in
                switch status {
                case .authorized, .limited:
                    self?.showImagePicker()
                default:
                    break
                }
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
