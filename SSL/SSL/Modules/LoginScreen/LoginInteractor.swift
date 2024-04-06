class LoginInteractor: PresenterToInteractorProtocol {
    var presenter: InteractorToPresenterProtocol?
    
    func performLogin(with user: UserDTO) {
        Task {
            do {
                let userDTO = try await LoginAPIManager.postLogin(email: user.email, password: user.password)
                
                if let userDTO = userDTO {
                    presenter?.loginSuccess(with: userDTO)
                } else {
                    presenter?.loginFailed(with: "Invalid email or password")
                }
            } catch {
                presenter?.loginFailed(with: error.localizedDescription)
            }
        }
    }
}
