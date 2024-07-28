import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    private let interactor: ProfileBusinessLogic
    private let router: SSLRoutingLogic
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .templateBackgroundColor
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameCard: ProfileTemplateCard = {
        let card = ProfileTemplateCard()
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()
    
    private let dataCard: ProfileTemplateCard = {
        let card = ProfileTemplateCard()
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()
    
    private let logoutButton: LogoutButton = {
        let button = LogoutButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(interactor: ProfileBusinessLogic, router: SSLRoutingLogic) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupNameCard()
        setupDataCard()
        setupLogoutButton()
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
        
        backgroundView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        contentView.addSubview(nameCard)
        contentView.addSubview(dataCard)
        contentView.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            nameCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            dataCard.topAnchor.constraint(equalTo: nameCard.bottomAnchor, constant: 20),
            dataCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dataCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            logoutButton.topAnchor.constraint(equalTo: dataCard.bottomAnchor, constant: 20),
            logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            logoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupNameCard() {
        let telegramPicView = TelegramPicView()
        telegramPicView.image = UIImage(named: "placeholder_image")
        telegramPicView.text = "@johndoe"
        
        let elements: [ProfileCardContentElement] = [
            .customView(telegramPicView),
            .spacing(height: 16),
            .nameLabel(text: "Шестакова Константин Константинович")
        ]
        nameCard.setupContentView(withElements: elements)
        nameCard.addEditButton()
    }
    
    private func setupDataCard() {
        let elements: [ProfileCardContentElement] = [
            .dataButton(text: "johndoe@example.com", isSecure: false),
            .spacing(height: 24),
            .dataButton(text: "huipenis", isSecure: true)
        ]
        dataCard.setupContentView(withElements: elements)
    }
    
    private func setupLogoutButton() {
        logoutButton.setCardText("Log out")
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    @objc private func logoutButtonTapped() {
        print("Logout button tapped")
    }
}
