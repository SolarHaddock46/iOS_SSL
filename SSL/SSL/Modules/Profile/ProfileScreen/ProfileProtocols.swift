protocol ProfileDataStore {}

protocol ProfileBusinessLogic {
    func requestInitForm(_ request: Profile.InitForm.Request)
    func fetchProfileData()
}

protocol ProfileWorkerLogic {}

protocol ProfilePresentationLogic {
    func presentInitForm(_ response: Profile.InitForm.Response)
    func presentProfileData(_ items: [ProfileViewController.Item])
}

protocol ProfileViewControllerProtocol: AnyObject {
    func displayInitForm(_ viewModel: Profile.InitForm.ViewModel)
    func displayProfileData(_ items: [ProfileViewController.Item])
}

protocol ProfileRoutingLogic {}
