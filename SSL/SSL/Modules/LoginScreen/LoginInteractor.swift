class LoginInteractor: PresenterToInteractorProtocol {
    var presenter: InteractorToPresenterProtocol?
    
    func performLogin(with user: UserDTO) {
        LoginAPIManager.postLogin(email: user.email, password: user.password) { [weak self] result in
            switch result {
            case .success(let userDTO):
                if let userDTO = userDTO {
                    self?.presenter?.loginSuccess(with: userDTO)
                } else {
                    self?.presenter?.loginFailed(with: "Invalid email or password")
                }
            case .failure(let error):
                self?.presenter?.loginFailed(with: error.localizedDescription)
            }
        }
    }
}
