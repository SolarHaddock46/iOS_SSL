import Foundation

final class ProfilePresenter: ProfilePresentationLogic {
    weak var viewController: ProfileViewControllerProtocol?

    func presentInitForm(_ response: Profile.InitForm.Response) {
        // Direct data fetching, so nothing to directly present here
    }

    func presentProfileData(_ items: [ProfileViewController.Item]) {
        viewController?.displayProfileData(items)
    }
}
