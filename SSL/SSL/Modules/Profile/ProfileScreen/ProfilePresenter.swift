import Foundation

final class ProfilePresenter: ProfilePresentationLogic {
    weak var viewController: ProfileViewControllerProtocol?

    // Internal by default
    func presentInitForm(_ response: Profile.InitForm.Response) {
        // Direct data fetching, so nothing to directly present here
    }

    // Internal by default
    func presentProfileData(_ items: [ProfileViewController.Item]) {
        // Pass profile data to the view controller for display
        viewController?.displayProfileData(items)
    }
}
