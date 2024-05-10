import UIKit

class UserInfoTextField: UITextField {

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
        return textField
    }()

    var isValid: Bool = true {
        didSet {
            textField.backgroundColor = isValid ? validTextFieldColor : invalidTextFieldColor
        }
    }
    
    var isTextEmpty: Bool {
        return enteredText?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }

    var textFieldHeight: CGFloat = 48.0

    init(placeholder: String, isSecure: Bool) {
        super.init(frame: .zero)
        backgroundColor = .white
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecure
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: textFieldHeight)
        ])
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserInfoTextField {
    var enteredText: String? {
        return textField.text
    }
}
