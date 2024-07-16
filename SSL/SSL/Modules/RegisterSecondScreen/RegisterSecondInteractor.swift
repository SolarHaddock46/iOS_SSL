import Foundation

class RegisterSecondInteractor: RegisterSecondInteractorProtocol {
    
    var presenter: RegisterSecondPresenterProtocol?
    let networkError = NetworkError.self
    
    func register(request: RegisterRequest) async throws {
        do {
            let response = try await RegisterSecondWorker.postRegister(requestData: request)
            self.presenter?.registerSuccess(with: response)
        } catch let error as NetworkError {
            self.presenter?.registerFailed(with: error)
        } catch {
            self.presenter?.registerFailed(with: self.networkError.unknownError)
            print(error.localizedDescription)
        }
    }
}
