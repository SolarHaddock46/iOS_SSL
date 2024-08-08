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
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(avatarDidTap))
        return recognizer
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .lightGray
        imageView.tintColor = .gray
        imageView.image = UIImage(named: "placeholder_image")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
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
        get { return avatarImageView.image }
        set { avatarImageView.image = newValue }
    }
    
    var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }
    
    weak var delegate: ProfilePicViewDelegate?
    
    init(frame: CGRect, showDescriptionLabel: Bool, initialAvatar: UIImage? = nil) {
        super.init(frame: frame)
        
        // Initialize with an avatar if provided
        if let avatarImage = initialAvatar {
            self.avatar = avatarImage
        }
        
        setupLayout(showDescriptionLabel: showDescriptionLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout(showDescriptionLabel: Bool) {
        addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 19),
            avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90)
        ]
        
        if showDescriptionLabel {
            addSubview(descriptionLabel)
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            constraints += [
                descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
                descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            ]
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func avatarDidTap() {
        delegate?.profilePicViewDidTapAvatar()
    }
}
