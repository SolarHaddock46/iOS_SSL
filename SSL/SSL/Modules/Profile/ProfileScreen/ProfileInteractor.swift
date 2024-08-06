import Foundation
import UIKit

final class ProfileInteractor: ProfileBusinessLogic, ProfileDataStore {
    private let presenter: ProfilePresentationLogic

    init(presenter: ProfilePresentationLogic) {
        self.presenter = presenter
    }

    func requestInitForm(_ request: Profile.InitForm.Request) {
        fetchProfileData()
    }

    func fetchProfileData() {
        // Simulate fetching profile data
        let telegramPicView = TelegramPicView()
        telegramPicView.image = UIImage(named: "placeholder_image")
        telegramPicView.text = "@johndoe"

        let nameCardElements: [ProfileCardContentElement] = [
            .customView(telegramPicView),
            .spacing(height: 16),
            .nameLabel(text: "Шестакова Константин Константинович")
        ]

        let dataCardElements: [ProfileCardContentElement] = [
            .dataButton(id: "emailButton", text: "johndoe@example.com", isSecure: false),
            .spacing(height: 24),
            .dataButton(id: "passwordButton", text: "huipenis", isSecure: true)
        ]

        let items: [ProfileViewController.Item] = [
            .nameCard(elements: nameCardElements),
            .dataCard(elements: dataCardElements),
            .logoutButton
        ]

        presenter.presentProfileData(items)
    }

    func handleLogout() {
        // Additional logout logic, if any
    }
}
