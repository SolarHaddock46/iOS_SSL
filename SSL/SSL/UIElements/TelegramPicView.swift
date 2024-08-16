import Foundation
import UIKit

class TelegramPicView: UIView {
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var text: String? {
        didSet {
            telegramLabel.text = text
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let telegramLabel: UILabel = {
        let label = UILabel()
        label.font = .onestMedium(ofSize: 12)
        label.textColor = .mainTextColor
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let telegramIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "telegram"))
        imageView.tintColor = .gray
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(imageView)
        addSubview(stackView)
        
        stackView.addArrangedSubview(telegramIcon)
        stackView.addArrangedSubview(telegramLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 90),
            imageView.heightAnchor.constraint(equalToConstant: 90),
            
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 11),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(copyText))
        telegramLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func copyText() {
        guard let text = telegramLabel.text else { return }
        UIPasteboard.general.string = text
    }
}
