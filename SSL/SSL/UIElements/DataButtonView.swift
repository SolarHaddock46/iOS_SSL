import UIKit
import Foundation

final class DataButtonView: UIView {
    let id: String
    let textLabel: SSLLabel
    let arrowImageView: UIImageView
    
    init(id: String, text: String, isSecure: Bool) {
        self.id = id
        textLabel = SSLLabel(localizationKey: text)
        textLabel.textColor = .mainTextColor
        textLabel.text = isSecure ? String(repeating: "*", count: text.count) : text
        
        arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrowImageView.contentMode = .scaleAspectFit
        
        super.init(frame: .zero)
        
        addSubview(textLabel)
        addSubview(arrowImageView)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 24),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
