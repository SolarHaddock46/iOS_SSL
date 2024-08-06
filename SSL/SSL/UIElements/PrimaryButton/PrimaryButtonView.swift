import UIKit

final class PrimaryButtonView: UIView {
    let id: String
    let textLabel: SSLLabel
    
    init(id: String, text: String) {
        self.id = id
        textLabel = SSLLabel(localizationKey: text)
        textLabel.textColor = .white
        
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .buttonBackgroundColor
        layer.cornerRadius = 10
        heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:)))
        addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func buttonTapped(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: .buttonTapped, object: self)
    }
}
