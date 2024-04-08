import Foundation

class LoginInteractor: PresenterToInteractorProtocol {
    var presenter: InteractorToPresenterProtocol?
    let networkError = NetworkError.self
    
    func performLogin(with user: UserDTO) {
        LoginAPIManager.postLogin(email: user.email, password: user.password) { result in
            switch result {
            case .success(let userDTO):
                if let userDTO = userDTO {
                    self.presenter?.loginSuccess(with: userDTO)
                } else {
                    self.presenter?.loginFailed(with: self.networkError.invalidUserDataFormat)
                }
            case .failure(let error):
                if let networkError = error as? NetworkError {
                    self.presenter?.loginFailed(with: networkError)
                } else {
                    self.presenter?.loginFailed(with: self.networkError.unknownError)
                }
            }
        }
    }
    
    
    private func handleError(_ error: Error) -> String {
        return "An error occurred: \(error.localizedDescription)"
    }
}
