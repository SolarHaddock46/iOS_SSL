import UIKit

enum ProfileCardContentElement: Hashable, Equatable {
    case nameLabel(text: String)
    case spacing(height: CGFloat)
    case dataButton(id: String, text: String, isSecure: Bool)
    case customView(UIView)
    case textField(id: String, placeholder: String, isSecure: Bool)
    case button(id: String, text: String)
}

final class ProfileViewController: UIViewController {
    private let interactor: ProfileBusinessLogic
    private let router: SSLRoutingLogic
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    enum Section {
        case main
        case newEmail
        case confirmationCode
        case oldPassword
        case newPassword
        case nameAndTelegram
    }
    
    enum Item: Hashable {
        case nameCard(elements: [ProfileCardContentElement])
        case dataCard(elements: [ProfileCardContentElement])
        case logoutButton
        case textFieldCard(elements: [ProfileCardContentElement])
        case buttonCard(elements: [ProfileCardContentElement])
        
        static func == (lhs: ProfileViewController.Item, rhs: ProfileViewController.Item) -> Bool {
            switch (lhs, rhs) {
            case (.nameCard(let lhsElements), .nameCard(let rhsElements)),
                 (.dataCard(let lhsElements), .dataCard(let rhsElements)),
                 (.textFieldCard(let lhsElements), .textFieldCard(let rhsElements)),
                 (.buttonCard(let lhsElements), .buttonCard(let rhsElements)):
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
                elements.forEach { hasher.combine($0) }
            case .dataCard(let elements):
                hasher.combine("dataCard")
                elements.forEach { hasher.combine($0) }
            case .logoutButton:
                hasher.combine("logoutButton")
            case .textFieldCard(let elements):
                hasher.combine("textFieldCard")
                elements.forEach { hasher.combine($0) }
            case .buttonCard(let elements):
                hasher.combine("buttonCard")
                elements.forEach { hasher.combine($0) }
            }
        }
    }
    
    init(interactor: ProfileBusinessLogic, router: SSLRoutingLogic) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
        
        if let presenter = interactor as? ProfilePresenter {
            presenter.viewController = self
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configureDataSource()
        interactor.requestInitForm(Profile.InitForm.Request())
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
            case .nameCard(let elements), .dataCard(let elements), .textFieldCard(let elements), .buttonCard(let elements):
                let stackView = self.createStackView()
                
                elements.forEach { element in
                    let view = self.createView(for: element)
                    stackView.addArrangedSubview(view)
                }
                
                cell.contentView.addSubview(stackView)
                self.configureConstraints(for: stackView, in: cell.contentView)
                
                // Add the edit button for name and telegram section in main section
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
    
    private func createNameLabel(withText text: String) -> SSLLabel {
        let label = SSLLabel(localizationKey: text, isHeading: true)
        label.textAlignment = .center
        return label
    }
    
    private func createDataButton(withId id: String, text: String, isSecure: Bool) -> UIView {
        let buttonContainer = UIView()
        
        let textLabel = SSLLabel(localizationKey: text)
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
        
        buttonContainer.isUserInteractionEnabled = true
        buttonContainer.accessibilityIdentifier = id
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dataButtonTapped(_:)))
        buttonContainer.addGestureRecognizer(tapGesture)
        
        return buttonContainer
    }
    
    @objc private func dataButtonTapped(_ sender: UITapGestureRecognizer) {
        guard let buttonContainer = sender.view else { return }
        
        switch buttonContainer.accessibilityIdentifier {
        case "emailButton":
            navigateToNewEmailSection()
        case "passwordButton":
            navigateToOldPasswordSection()
        default:
            break
        }
    }
    
    private func createEditButton() -> UIButton {
        let button = UIButton(type: .system)
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let editIcon = UIImage(systemName: "pencil", withConfiguration: configuration)
        
        button.setImage(editIcon, for: .normal)
        button.tintColor = .buttonBackgroundColor
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(editNameAndTelegramButtonTapped), for: .touchUpInside)
        
        return button
    }
    
    @objc private func editNameAndTelegramButtonTapped() {
        navigateToNameAndTelegramSection()
    }
    
    private func createLogoutButton() -> PrimaryButtonContainer {
        let buttonContainer = PrimaryButtonContainer(id: "logoutButton", localizationKey: "Log out")
        buttonContainer.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return buttonContainer
    }
    
    @objc private func logoutButtonTapped() {
        print("Logout button tapped")
    }
    
    private func createTextField(withId id: String, placeholder: String, isSecure: Bool) -> UserInfoTextFieldContainer {
        let textFieldContainer = UserInfoTextFieldContainer(placeholder: placeholder, isSecure: isSecure)
        textFieldContainer.accessibilityIdentifier = id
        return textFieldContainer
    }
    
    private func createButton(withId id: String, text: String) -> PrimaryButtonContainer {
        let buttonContainer = PrimaryButtonContainer(id: "", localizationKey: text)
        buttonContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:))))
        buttonContainer.accessibilityIdentifier = id
        return buttonContainer
    }

    @objc private func buttonTapped(_ sender: UITapGestureRecognizer) {
        guard let buttonContainer = sender.view as? PrimaryButtonContainer,
              let identifier = buttonContainer.accessibilityIdentifier else {
            return
        }
        
        print("Button tapped: $$identifier)") // Debug print statement
        
        switch identifier {
        case "saveNewEmailButton":
            navigateToConfirmationCodeSection()
        case "confirmButton":
            navigateToMainSection()
        case "changePasswordButton":
            navigateToNewPasswordSection()
        case "savePasswordButton":
            navigateToMainSection()
        case "saveNameAndTelegramButton":
            navigateToMainSection()
        default:
            break
        }
    }

    private func createView(for element: ProfileCardContentElement) -> UIView {
        switch element {
        case .nameLabel(let text):
            return createNameLabel(withText: text)
        case .dataButton(let id, let text, let isSecure):
            return createDataButton(withId: id, text: text, isSecure: isSecure)
        case .customView(let customView):
            return customView
        case .spacing(let height):
            let spacerView = UIView()
            spacerView.heightAnchor.constraint(equalToConstant: height).isActive = true
            return spacerView
        case .textField(let id, let placeholder, let isSecure):
            return createTextField(withId: id, placeholder: placeholder, isSecure: isSecure)
        case .button(let id, let text):
            return createButton(withId: id, text: text)
        }
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

    private func navigateToNewEmailSection() {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.newEmail])
        snapshot.appendItems([
            .textFieldCard(elements: [
                .textField(id: "newEmailTextField", placeholder: "New Email", isSecure: false),
                .button(id: "saveNewEmailButton", text: "Save New Email")
            ])
        ], toSection: .newEmail)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func navigateToConfirmationCodeSection() {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.confirmationCode])
        snapshot.appendItems([
            .textFieldCard(elements: [
                .textField(id: "confirmationCodeTextField", placeholder: "Confirmation Code", isSecure: false),
                .button(id: "confirmButton", text: "Confirm")
            ])
        ], toSection: .confirmationCode)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func navigateToOldPasswordSection() {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.oldPassword])
        snapshot.appendItems([
            .textFieldCard(elements: [
                .textField(id: "oldPasswordTextField", placeholder: "Old Password", isSecure: true),
                .button(id: "changePasswordButton", text: "Change Password")
            ])
        ], toSection: .oldPassword)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func navigateToNewPasswordSection() {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.newPassword])
        snapshot.appendItems([
            .textFieldCard(elements: [
                .textField(id: "newPasswordTextField", placeholder: "New Password", isSecure: true),
                .spacing(height: 16),
                .textField(id: "confirmNewPasswordTextField", placeholder: "Confirm New Password", isSecure: true),
                .button(id: "savePasswordButton", text: "Save Password")
            ])
        ], toSection: .newPassword)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func navigateToNameAndTelegramSection() {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.nameAndTelegram])
        snapshot.appendItems([
            .textFieldCard(elements: [
                .textField(id: "firstNameTextField", placeholder: "First Name", isSecure: false),
                .spacing(height: 16),
                .textField(id: "middleNameTextField", placeholder: "Middle Name", isSecure: false),
                .spacing(height: 16),
                .textField(id: "lastNameTextField", placeholder: "Last Name", isSecure: false),
                .spacing(height: 16),
                .textField(id: "telegramUsernameTextField", placeholder: "Telegram Username", isSecure: false),
                .button(id: "saveNameAndTelegramButton", text: "Save")
            ])
        ], toSection: .nameAndTelegram)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func navigateToMainSection() {
        interactor.requestInitForm(Profile.InitForm.Request())
    }

}

extension ProfileViewController: ProfileViewControllerProtocol {
    func displayInitForm(_ viewModel: Profile.InitForm.ViewModel) {
        // Handle the initial form view model, typically not needed if fetching the data directly on view load
    }

    func displayProfileData(_ items: [Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}
