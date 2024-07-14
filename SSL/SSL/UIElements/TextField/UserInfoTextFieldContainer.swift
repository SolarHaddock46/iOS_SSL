import UIKit

class UserInfoTextFieldContainer: UIView {

    private let textField: UserInfoTextField

    init(placeholder: String, isSecure: Bool) {
        self.textField = UserInfoTextField(placeholder: placeholder, isSecure: isSecure)
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    func getTextField() -> UserInfoTextField {
        return textField
    }
    
    var enteredText: String? {
        return textField.enteredText
    }
}
