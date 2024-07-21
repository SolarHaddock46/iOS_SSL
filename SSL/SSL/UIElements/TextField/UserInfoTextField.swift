import UIKit

class UserInfoTextField: UIView, UITextFieldDelegate {
    private let validTextFieldColor: UIColor = .validTextColor
    private let invalidTextFieldColor: UIColor = .invalidTextFieldColor
    private let borderColor: UIColor = .textFieldBorderColor
    private let cornerRadius: CGFloat = 8.0
    
    private lazy var textField: InsetedTextField = {
        let textField = InsetedTextField()
        textField.backgroundColor = validTextFieldColor
        textField.font = UIFont(name: "Onest", size: 16)
        textField.layer.cornerRadius = cornerRadius
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = borderColor.cgColor
        textField.delegate = self
        return textField
    }()
    
    var isValid: Bool = true {
        didSet {
            DispatchQueue.main.async {
                self.textField.backgroundColor = self.isValid ? self.validTextFieldColor : self.invalidTextFieldColor
            }
        }
    }
    
    var isTextEmpty: Bool {
        return textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
    
    var textFieldHeight: CGFloat = 48.0
    
    init(placeholder: String, isSecure: Bool) {
        super.init(frame: .zero)
        backgroundColor = .white
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecure
        addSubview(textField)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
}

extension UserInfoTextField {
    var text: String? {
        return textField.text
    }
}
