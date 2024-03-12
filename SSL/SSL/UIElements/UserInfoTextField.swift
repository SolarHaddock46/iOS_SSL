import UIKit

class UserInfoTextField: UITextField {

    private let validTextFieldColor: UIColor = .white
    private let invalidTextFieldColor: UIColor = UIColor(red: 0.89, green: 0.411, blue: 0.345, alpha: 0.12)
    private let borderColor: UIColor = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 1.0)
    private let cornerRadius: CGFloat = 8.0
    
    private lazy var textField: InsetedTextField = {
        let textField = InsetedTextField()
        textField.backgroundColor = validTextFieldColor
        textField.font = .systemFont(ofSize: 16, weight: .regular)
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
    
    var textFieldHeight: CGFloat = 48.0
    
    init(placeholder: String, isSecure: Bool) {
        super.init(frame: .zero)
        setup(placeholder: placeholder, isSecure: isSecure)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(placeholder: String, isSecure: Bool) {
        backgroundColor = .white
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecure
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: textFieldHeight)
        ])
    }
}
