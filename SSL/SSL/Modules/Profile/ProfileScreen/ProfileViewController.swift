import UIKit

enum ProfileCardContentElement: Hashable {
    case nameLabel(text: String)
    case spacing(height: CGFloat)
    case dataButton(id: String, text: String, isSecure: Bool)
    case customView(UIView)
    case textField(id: String, placeholder: String, isSecure: Bool)
    case button(id: String, text: String)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    private let interactor: ProfileBusinessLogic
    private let router: SSLRoutingLogic

    private var contentView: UIView!
    private var headingLabel: SSLLabel!
    private var listCollectionView: UICollectionView!
    private var dataSource: DataSource!

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>

    enum Section: Int {
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
        setupViews()
        configureDataSource()
        navigateToMainSection()

        NotificationCenter.default.addObserver(self, selector: #selector(handleButtonTap(_:)), name: .buttonTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEditButtonTap(_:)), name: .editButtonTapped, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .buttonTapped, object: nil)
        NotificationCenter.default.removeObserver(self, name: .editButtonTapped, object: nil)
    }

    private func setupViews() {
        contentView = UIView()
        contentView.backgroundColor = .templateBackgroundColor
        view.addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        headingLabel = SSLLabel(localizationKey: "Profile", color: .mainTextColor, size: 34, isMedium: true)
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headingLabel)

        listCollectionView = Self.createCollectionView()
        contentView.addSubview(listCollectionView)

        listCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            listCollectionView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 16),
            listCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            listCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            listCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private static func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            section.interGroupSpacing = 20
            return section
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UniversalCollectionViewCell, Item> { (cell, indexPath, item) in
            cell.configure(with: item)
        }

        dataSource = DataSource(collectionView: listCollectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }

    // MARK: - Navigation Methods

    private func navigateToMainSection() {
        interactor.requestInitForm(Profile.InitForm.Request())
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

    // MARK: - ViewController Protocol Methods

    func displayInitForm(_ viewModel: Profile.InitForm.ViewModel) {
        // Convert response items to viewable items
        // This may need to be adjusted based on your data structure
    }

    func displayProfileData(_ items: [ProfileViewController.Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }

    // MARK: - Action Methods

    @objc private func handleButtonTap(_ notification: Notification) {
        guard let tappedView = notification.object else {
            return
        }

        if let buttonView = tappedView as? DataButtonView {
            dataButtonTapped(buttonView)
        } else if let buttonContainer = tappedView as? PrimaryButtonView {
            buttonTapped(buttonContainer)
        }
    }

    @objc private func handleEditButtonTap(_ notification: Notification) {
        navigateToNameAndTelegramSection()
    }

    private func dataButtonTapped(_ buttonView: DataButtonView) {
        switch buttonView.id {
        case "emailButton":
            navigateToNewEmailSection()
        case "passwordButton":
            navigateToOldPasswordSection()
        default:
            break
        }
    }

    private func buttonTapped(_ buttonContainer: PrimaryButtonView) {
        switch buttonContainer.id {
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

    private func editNameAndTelegramButtonTapped() {
        navigateToNameAndTelegramSection()
    }
}

extension Notification.Name {
    static let buttonTapped = Notification.Name("buttonTapped")
    static let editButtonTapped = Notification.Name("editButtonTapped")
}
