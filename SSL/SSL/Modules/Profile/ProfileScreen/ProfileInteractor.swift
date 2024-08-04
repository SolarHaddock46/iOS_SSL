import Foundation
import UIKit

final class ProfileInteractor: ProfileBusinessLogic, ProfileDataStore {
    private let presenter: ProfilePresentationLogic

    init(presenter: ProfilePresentationLogic) {
        self.presenter = presenter
    }

    // Internal by default
    func requestInitForm(_ request: Profile.InitForm.Request) {
        fetchProfileData()
    }

    // Internal by default
    func fetchProfileData() {
        // Simulate fetching profile data
        let telegramPicView = TelegramPicView()
        telegramPicView.image = UIImage(named: "placeholder_image")
        telegramPicView.text = "@johndoe"

        let nameCardElements: [ProfileCardContentElement] = [
            .customView(telegramPicView),
            .spacing(height: 16),
            .nameLabel(text: "Шестакова Константин Константинович") // Name in Cyrillic
        ]

        let dataCardElements: [ProfileCardContentElement] = [
            .dataButton(id: "emailButton", text: "johndoe@example.com", isSecure: false),
            .spacing(height: 24),
            .dataButton(id: "passwordButton", text: "huipenis", isSecure: true) // Consider changing this to a realistic placeholder
        ]

        let items: [ProfileViewController.Item] = [
            .nameCard(elements: nameCardElements),
            .dataCard(elements: dataCardElements),
            .logoutButton
        ]

        // Pass the fetched data to the presenter
        presenter.presentProfileData(items)
    }
}
