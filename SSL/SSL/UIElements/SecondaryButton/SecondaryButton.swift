import UIKit

final class SecondaryButton: UIButton {
    
    init(localizationKey: String) {
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        let titleLabel = SSLLabel(localizationKey: localizationKey, color: .buttonBackgroundColor)
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            widthAnchor.constraint(equalTo: titleLabel.widthAnchor),
            heightAnchor.constraint(equalTo: titleLabel.heightAnchor)
        ])
    }
        
    init(attributedTitle: NSAttributedString) {
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        let titleLabel = UILabel()
        titleLabel.attributedText = attributedTitle
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            widthAnchor.constraint(equalTo: titleLabel.widthAnchor),
            heightAnchor.constraint(equalTo: titleLabel.heightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
