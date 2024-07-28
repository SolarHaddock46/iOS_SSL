import Foundation

final class ProfileInteractor: ProfileBusinessLogic, ProfileDataStore {
    private let presenter: ProfilePresentationLogic

    init(presenter: ProfilePresentationLogic) {
        self.presenter = presenter
    }

    func requestInitForm(_ request: Profile.InitForm.Request) {
        DispatchQueue.main.async {
            self.presenter.presentInitForm(Profile.InitForm.Response())
        }
    }
}
