import UIKit

final class RegisterSecondViewController: TemplateViewController, RegisterSecondViewControllerProtocol {
    var interactor: RegisterSecondInteractorProtocol
    private let router: SSLRoutingLogic
    private var formData: RegisterFirstFormData
    private var dialog: RegisterSecondDialog?
    
    private var elements: [ContentElement] = {
        return [
            .heading(text: "Register an account"),
            .spacing(height: 40),
            .textField(name: "Email", placeholder: NSLocalizedString("Email", comment: ""), isSecure: false),
            .spacing(height: 18),
            .textField(name: "Telegram", placeholder: NSLocalizedString("Telegram (without @)", comment: ""), isSecure: false),
            .spacing(height: 18),
            .textField(name: "Password1", placeholder: NSLocalizedString("Password", comment: ""), isSecure: true),
            .spacing(height: 18),
            .textField(name: "Password2", placeholder: NSLocalizedString("Repeat password", comment: ""), isSecure: true),
            .spacing(height: 40),
            .primaryButton(title: "Register", action: #selector(registerButtonTapped(_:)))
        ]
    }()

    init(formData: RegisterFirstFormData, interactor: RegisterSecondInteractorProtocol, router: SSLRoutingLogic) {
        self.formData = formData
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView(withElements: elements)
    }
    
    private func isFormValid() -> Bool {
        let emailTextField = textFieldsByName["Email"]
        let telegramTextField = textFieldsByName["Telegram"]
        let password1TextField = textFieldsByName["Password1"]
        let password2TextField = textFieldsByName["Password2"]
        
        emailTextField?.isValid = SSLValidator.emailIsValid(email: emailTextField?.text ?? "")
        telegramTextField?.isValid = SSLValidator.telegramIsValid(telegram: telegramTextField?.text ?? "")
        password1TextField?.isValid = !(password1TextField?.isTextEmpty ?? true)
        password2TextField?.isValid = !(password2TextField?.isTextEmpty ?? true)
        
        if password1TextField?.text != password2TextField?.text {
            password2TextField?.isValid = false
        }
        
        return emailTextField?.isValid ?? false &&
            telegramTextField?.isValid ?? false &&
            password1TextField?.isValid ?? false &&
            password2TextField?.isValid ?? false
    }
    
    @objc func registerButtonTapped(_ sender: UIButton) {
        if isFormValid() {
            let request = RegisterRequest(
                firstName: formData.firstName,
                lastName: formData.secondName,
                fatherName: formData.fatherName,
                telegram: getTextFieldValue(forName: "Telegram") ?? "",
                email: getTextFieldValue(forName: "Email") ?? "",
                password1: getTextFieldValue(forName: "Password1") ?? "",
                password2: getTextFieldValue(forName: "Password2") ?? "",
                hsePass: formData.hsePass,
                acceptConditions: formData.conditionsAccepted,
                imageData: formData.profilePicData
            )
            
            Task(priority: .high) {
                do {
                    try await interactor.register(request: request)
                }
            }
        }
    }
}
