import UIKit

class TemplateViewController: UIViewController {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .templateBackgroundColor
        return view
    }()

//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor(red: 0.173, green: 0.212, blue: 0.251, alpha: 1)
//        label.font = UIFont(name: "Rubik-ExtraBold", size: 34)
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineHeightMultiple = 1.24
//        label.textAlignment = .center
//        label.attributedText = NSMutableAttributedString(string: "Soft Skills Lab", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
//        return label
//    }()

    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()

    let navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
//        backgroundView.addSubview(titleLabel)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(navigationBar)
        
        backgroundView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            titleLabel.widthAnchor.constraint(equalToConstant: 256),
//            titleLabel.heightAnchor.constraint(equalToConstant: 52),
//            titleLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor, constant: -0.5),
//            titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 131),
            
            navigationBar.topAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            
            contentView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            contentView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16)
        ])
    }

    func addContentSubview(_ view: UIView, withInnerMargin margin: CGFloat = 16) {
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin)
        ])
    }
}
