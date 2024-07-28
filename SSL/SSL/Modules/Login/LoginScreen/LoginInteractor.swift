import Foundation

class LoginInteractor: LoginInteractorProtocol {
    var presenter: LoginPresenterProtocol?
    
    func login(email: String, password: String) async throws {
        do {
            let loginEndpoint = LoginEndpoint()
            let loginRequestDTO = LoginRequestDTO(email: email, password: password)
            
            let loginResponseDTO: LoginResponseDTO = try await SSLNetworkService.shared.request(
                endpoint: loginEndpoint,
                requestDTO: loginRequestDTO
            )
            
            presenter?.presentLoginResult(result: .success(loginResponseDTO))
        } catch let error as NetworkError {
            presenter?.presentLoginResult(result: .failure(error))
        } catch {
            presenter?.presentLoginResult(result: .failure(NetworkError.unknownError))
        }
    }
}
