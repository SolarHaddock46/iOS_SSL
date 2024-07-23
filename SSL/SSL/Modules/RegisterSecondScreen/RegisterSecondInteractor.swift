import Foundation

class RegisterSecondInteractor: RegisterSecondInteractorProtocol {
    var presenter: RegisterSecondPresenterProtocol?
    let networkError = NetworkError.self
    
    func register(request: RegisterRequest) async throws {
        do {
            let registerEndpoint = RegisterEndpoint()
            let response: RegisterResponse = try await SSLNetworkService.shared.request(
                endpoint: registerEndpoint,
                requestDTO: request
            )
            self.presenter?.registerSuccess(with: response)
        } catch let error as NetworkError {
            self.presenter?.registerFailed(with: error)
        } catch {
            self.presenter?.registerFailed(with: self.networkError.unknownError)
            print(error.localizedDescription)
        }
    }
}
