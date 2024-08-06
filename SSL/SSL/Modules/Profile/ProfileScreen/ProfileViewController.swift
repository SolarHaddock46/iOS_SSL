import UIKit

enum ProfileCardContentElement: Hashable {
    case nameLabel(text: String)
    case subtext(text: String)
    case label(text: String)
    case heading(text: String)
    case dataButton(id: String, text: String, isSecure: Bool)
    case customView(UIView)
    case spacing(height: CGFloat)
    case textField(id: String, placeholder: String, isSecure: Bool)
    case button(id: String, text: String)
    case logoutButton
    case secondaryButton(id: String, text: String)
    case secondaryButtonWithAttributedTitle(id: String, attributedTitle: NSAttributedString)
}

class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    private let interactor: ProfileBusinessLogic
    private let router: SSLRoutingLogic

    private let resendLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = UIFont.onest(ofSize: 16)

        let attributedText = NSMutableAttributedString(string: "Didn't receive the code? Resend")
        let range = (attributedText.string as NSString).range(of: "Resend")

        attributedText.addAttribute(.font, value: UIFont.onestBold(ofSize: 16), range: range)

        label.textAlignment = .left
        label.attributedText = attributedText

        return label
    }()

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
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogoutButtonTap(_:)), name: .logoutButtonTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSecondaryButtonTap(_:)), name: .secondaryButtonTapped, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .buttonTapped, object: nil)
        NotificationCenter.default.removeObserver(self, name: .editButtonTapped, object: nil)
        NotificationCenter.default.removeObserver(self, name: .logoutButtonTapped, object: nil)
        NotificationCenter.default.removeObserver(self, name: .secondaryButtonTapped, object: nil)
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

        listCollectionView = ProfileAssembly.createCollectionView()
        contentView.addSubview(listCollectionView)

        listCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            listCollectionView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor),
            listCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            listCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            listCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProfileCollectionViewCell, Item> { (cell, indexPath, item) in
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
                .heading(text: "Edit email"),
                .spacing(height: 28),
                .textField(id: "newEmailTextField", placeholder: "New Email", isSecure: false),
                .spacing(height: 28),
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
                .heading(text: "Edit email"),
                .spacing(height: 16),
                .subtext(text: "We have sent you a confirmation code, please check your email"),
                .spacing(height: 28),
                .textField(id: "confirmationCodeTextField", placeholder: "Confirmation Code", isSecure: false),
                .spacing(height: 8),
                .secondaryButtonWithAttributedTitle(id: "resendCodeButton", attributedTitle: resendLabel.attributedText ?? NSAttributedString(string: "")),
                .spacing(height: 20),
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
                .heading(text: "Change Password"),
                .spacing(height: 28),
                .textField(id: "oldPasswordTextField", placeholder: "Old Password", isSecure: true),
                .spacing(height: 28),
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
                .heading(text: "Change Password"),
                .spacing(height: 16),
                .subtext(text: "Your password must contain at least 8 Latin letters, numbers, or characters"),
                .spacing(height: 32),
                .textField(id: "newPasswordTextField", placeholder: "New Password", isSecure: true),
                .spacing(height: 16),
                .textField(id: "confirmNewPasswordTextField", placeholder: "Confirm New Password", isSecure: true),
                .spacing(height: 32),
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
                .spacing(height: 18),
                .textField(id: "middleNameTextField", placeholder: "Middle Name", isSecure: false),
                .spacing(height: 18),
                .textField(id: "lastNameTextField", placeholder: "Last Name", isSecure: false),
                .spacing(height: 18),
                .textField(id: "telegramUsernameTextField", placeholder: "Telegram Username", isSecure: false),
                .spacing(height: 18),
                .button(id: "saveNameAndTelegramButton", text: "Save")
            ])
        ], toSection: .nameAndTelegram)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - ViewController Protocol Methods

    func displayInitForm(_ viewModel: Profile.InitForm.ViewModel) {
        // Convert response items to viewable items
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

    @objc private func handleLogoutButtonTap(_ notification: Notification) {
        presentLogoutConfirmation()
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

    @objc private func handleSecondaryButtonTap(_ notification: Notification) {
        guard let tappedView = notification.object as? SecondaryButtonView else {
            return
        }

        switch tappedView.id {
        case "resendCodeButton":
            // Handle resend code action
            print("Resend code button tapped")
        default:
            break
        }
    }

    private func editNameAndTelegramButtonTapped() {
        navigateToNameAndTelegramSection()
    }

    private func presentLogoutConfirmation() {
        let title = NSLocalizedString("Are you sure that you want to log out?", comment: "")
        let confirmActionTitle = NSLocalizedString("Log out", comment: "")
        let cancelActionTitle = NSLocalizedString("Cancel", comment: "")

        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: confirmActionTitle, style: .destructive) { _ in
            self.handleLogout()
        }
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        present(alertController, animated: true)
    }

    private func handleLogout() {
        print("User confirmed logout")
        router.navigate(source: self, destination: .registerFirst, data: nil) // роут сделать на логин
    }
}
