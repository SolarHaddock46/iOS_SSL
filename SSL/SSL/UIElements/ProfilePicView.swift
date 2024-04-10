import Foundation
import UIKit

protocol ProfilePicViewDelegate: AnyObject {
    func profilePicViewDidTapAvatar()
    func requestPhotoLibraryAccess()
}

final class ProfilePicView: UIView {
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 138)
    }
    
    private lazy var avatarChangeRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(avatarDidTap))
        return recognizer
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.layer.cornerRadius = 50
        imageView.backgroundColor = .lightGray
        imageView.tintColor = .gray
        imageView.image = UIImage(systemName: "person.fill")
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderColor = UIColor.link.cgColor
        imageView.layer.borderWidth = 3
        
        imageView.addGestureRecognizer(avatarChangeRecognizer)
        
        return imageView
    }()
    
    var avatar: UIImage? {
        get {
            avatarImageView.image
        }
        set {
            avatarImageView.image = newValue
        }
    }
    
    weak var delegate: ProfilePicViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor),
            avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func avatarDidTap() {
        delegate?.profilePicViewDidTapAvatar()
    }
    
}
