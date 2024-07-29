import UIKit

enum ProfileCardContentElement: Hashable, Equatable {
    case nameLabel(text: String)
    case spacing(height: CGFloat)
    case dataButton(text: String, isSecure: Bool)
    case customView(UIView)
}

final class ProfileViewController: UIViewController {
    private let interactor: ProfileBusinessLogic
    private let router: SSLRoutingLogic
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    enum Section {
        case main
    }
    
    enum Item: Hashable {
        case nameCard(elements: [ProfileCardContentElement])
        case dataCard(elements: [ProfileCardContentElement])
        case logoutButton
        
        static func == (lhs: ProfileViewController.Item, rhs: ProfileViewController.Item) -> Bool {
            switch (lhs, rhs) {
            case (.nameCard(let lhsElements), .nameCard(let rhsElements)), (.dataCard(let lhsElements), .dataCard(let rhsElements)):
                return lhsElements == rhsElements
            case (.logoutButton, .logoutButton):
                return true
            default:
                return false
            }
        }
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .nameCard(let elements):
                hasher.combine("nameCard")
                elements.forEach { element in
                    hasher.combine(element)
                }
            case .dataCard(let elements):
                hasher.combine("dataCard")
                elements.forEach { element in
                    hasher.combine(element)
                }
            case .logoutButton:
                hasher.combine("logoutButton")
            }
        }
    }
    
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
        setupCollectionView()
        configureDataSource()
        populateData()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            section.interGroupSpacing = 20
            return section
        }
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .templateBackgroundColor
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Item> { [weak self] cell, indexPath, item in
            guard let self = self else { return }
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            
            switch item {
            case .nameCard(let elements), .dataCard(let elements):
                let stackView = self.createStackView()
                
                elements.forEach { element in
                    let view = self.createView(for: element)
                    stackView.addArrangedSubview(view)
                }
                
                cell.contentView.addSubview(stackView)
                self.configureConstraints(for: stackView, in: cell.contentView)
                
                if case .nameCard = item {
                    let editButton = self.createEditButton()
                    cell.contentView.addSubview(editButton)
                    self.configureEditButtonConstraints(editButton, in: cell.contentView)
                }
            case .logoutButton:
                let button = self.createLogoutButton()
                cell.contentView.addSubview(button)
                button.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    button.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 20),
                    button.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
                    button.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
                    button.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -20),
                    button.heightAnchor.constraint(equalToConstant: 60)
                ])
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
    
    private func populateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        
        let telegramPicView = TelegramPicView()
        telegramPicView.image = UIImage(named: "placeholder_image")
        telegramPicView.text = "@johndoe"
        
        let nameCardElements: [ProfileCardContentElement] = [
            .customView(telegramPicView),
            .spacing(height: 16),
            .nameLabel(text: "Шестакова Константин Константинович")
        ]
        
        let dataCardElements: [ProfileCardContentElement] = [
            .dataButton(text: "johndoe@example.com", isSecure: false),
            .spacing(height: 24),
            .dataButton(text: "huipenis", isSecure: true)
        ]
        
        let items: [Item] = [
            .nameCard(elements: nameCardElements),
            .dataCard(elements: dataCardElements),
            .logoutButton
        ]
        
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 16
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.shadowOpacity = 0.1
        stackView.layer.shadowOffset = CGSize(width: 0, height: 2)
        stackView.layer.shadowRadius = 4
        stackView.layoutMargins = UIEdgeInsets(top: 28, left: 16, bottom: 28, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }
    
    private func createView(for element: ProfileCardContentElement) -> UIView {
        switch element {
        case .nameLabel(let text):
            return createNameLabel(withText: text)
        case .dataButton(let text, let isSecure):
            return createDataButton(withText: text, isSecure: isSecure)
        case .customView(let customView):
            return customView
        case .spacing(let height):
            let spacerView = UIView()
            spacerView.heightAnchor.constraint(equalToConstant: height).isActive = true
            return spacerView
        }
    }
    
    private func createNameLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.font = .onestMedium(ofSize: 24)
        label.textColor = .mainTextColor
        label.text = text
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }
    
    private func createDataButton(withText text: String, isSecure: Bool) -> UIView {
        let buttonContainer = UIView()
        
        let textLabel = UILabel()
        textLabel.font = .onestMedium(ofSize: 16)
        textLabel.textColor = .mainTextColor
        textLabel.text = isSecure ? String(repeating: "*", count: text.count) : text
        
        let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrowImageView.contentMode = .scaleAspectFit
        
        buttonContainer.addSubview(textLabel)
        buttonContainer.addSubview(arrowImageView)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            buttonContainer.heightAnchor.constraint(equalToConstant: 24),
            
            textLabel.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor),
            textLabel.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor),
            arrowImageView.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return buttonContainer
    }
    
    private func createEditButton() -> UIButton {
        let button = UIButton(type: .system)
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let editIcon = UIImage(systemName: "pencil", withConfiguration: configuration)
        
        button.setImage(editIcon, for: .normal)
        button.tintColor = .buttonBackgroundColor
        button.backgroundColor = .clear
        
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        return button
    }
    
    @objc private func editButtonTapped() {
        print("Edit button tapped.")
    }

    private func createLogoutButton() -> LogoutButton {
        let button = LogoutButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setCardText("Log out")
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return button
    }
    
    @objc private func logoutButtonTapped() {
        print("Logout button tapped")
    }
    
    private func configureConstraints(for stackView: UIStackView, in contentView: UIView) {
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func configureEditButtonConstraints(_ editButton: UIButton, in contentView: UIView) {
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            editButton.widthAnchor.constraint(equalToConstant: 30),
            editButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
