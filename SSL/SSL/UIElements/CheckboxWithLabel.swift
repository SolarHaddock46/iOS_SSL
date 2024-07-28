import UIKit

class CheckboxWithLabel: UIView {

    private let checkbox: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        button.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        button.tintColor = .systemBlue
        return button
    }()

    private let label: SSLLabel

    init(localizationKey: String) {
        label = SSLLabel(localizationKey: localizationKey, size: 13)
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(checkbox)
        addSubview(label)

        checkbox.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            checkbox.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkbox.topAnchor.constraint(equalTo: topAnchor),
            checkbox.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            label.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 8),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    @objc private func checkboxTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        updateCheckboxImages()
    }

    private func updateCheckboxImages() {
        let rectangleImage = UIImage(systemName: "square")?.withTintColor(.buttonBackgroundColor, renderingMode: .alwaysOriginal)
        let checkmarkImage = UIImage(systemName: "checkmark.square.fill")?.withTintColor(.buttonBackgroundColor, renderingMode: .alwaysOriginal)
        
        checkbox.setImage(rectangleImage, for: .normal)
        checkbox.setImage(checkmarkImage, for: .selected)
    }

    func setChecked(_ checked: Bool) {
        checkbox.isSelected = checked
        updateCheckboxImages()
    }
}

extension CheckboxWithLabel {
    var isChecked: Bool {
        get {
            return checkbox.isSelected
        }
        set {
            checkbox.isSelected = newValue
            updateCheckboxImages()
        }
    }
}
