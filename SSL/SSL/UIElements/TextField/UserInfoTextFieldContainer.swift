import UIKit

final class UserInfoTextFieldContainer: UIView {
    let textField: UserInfoTextField
    
    init(placeholder: String, isSecure: Bool) {
        textField = UserInfoTextField(placeholder: placeholder, isSecure: isSecure)
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            heightAnchor.constraint(equalToConstant: textField.textFieldHeight)
        ])
    }
    
    var isValid: Bool {
        get { textField.isValid }
        set { textField.isValid = newValue }
    }
}
