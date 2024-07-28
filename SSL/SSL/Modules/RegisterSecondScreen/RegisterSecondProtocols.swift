import Foundation

protocol RegisterSecondDataStore {}

protocol RegisterSecondWorkerLogic {}

protocol RegisterSecondInteractorProtocol: AnyObject {
    var presenter: RegisterSecondPresenterProtocol? { get set }
    func register(request: RegisterRequest) async throws
}

protocol RegisterSecondPresenterProtocol: AnyObject {
    var viewController: RegisterSecondViewControllerProtocol? { get set }
    func registerSuccess(with response: RegisterResponse)
    func registerFailed(with error: NetworkError)
}

protocol RegisterSecondViewControllerProtocol: AnyObject {
    var interactor: RegisterSecondInteractorProtocol { get set }
}
