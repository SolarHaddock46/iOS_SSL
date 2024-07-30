import Foundation

final class ProfilePresenter: ProfilePresentationLogic {
    weak var viewController: ProfileViewControllerProtocol?

    func presentInitForm(_ response: Profile.InitForm.Response) {
        // No need to do anything here since we're fetching the data directly
    }

    func presentProfileData(_ items: [ProfileViewController.Item]) {
        // Pass the profile data to the view controller
        viewController?.displayProfileData(items)
    }
}
