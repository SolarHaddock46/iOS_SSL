import Foundation
import UIKit

protocol ProfilePicViewDelegate: AnyObject {
    func profilePicViewDidTapAvatar()
    func requestPhotoLibraryAccess()
}

final class ProfilePicView: UIView {
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 154)
    }
    
    private lazy var avatarChangeRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(avatarDidTap))
        return recognizer
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .lightGray
        imageView.tintColor = .gray
        
        let placeholderImage = UIImage(named: "placeholder_image")
        imageView.image = placeholderImage
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.borderWidth = 0
        
        imageView.addGestureRecognizer(avatarChangeRecognizer)
        
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.onestLight(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    var avatar: UIImage? {
        get {
            avatarImageView.image
        }
        set {
            avatarImageView.image = newValue
        }
    }
    
    var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }
    
    weak var delegate: ProfilePicViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(avatarImageView)
        addSubview(descriptionLabel)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 19),
            avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            
            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    @objc private func avatarDidTap() {
        delegate?.profilePicViewDidTapAvatar()
    }
}
