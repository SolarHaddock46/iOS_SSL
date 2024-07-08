import Foundation

struct Tokens: Codable {
    let refresh: String
    let access: String
    let id: Int
}

struct UserDTO: Codable {
    let email: String
    let password: String
    let tokens: Tokens
}

struct LoginRequestDTO: Codable {
    let email: String
    let password: String
}

struct LoginErrorDetail: Codable {
    let detail: String
}

final class LoginAPIManager {
    static func postLogin(email: String, password: String) async throws -> UserDTO {
        let apiRoutes = APIRoutes()
        guard let baseURL = apiRoutes.baseURL else { throw NetworkError.internalError }
        let networkError = NetworkError.self
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = apiRoutes.loginRoute
        
        guard let url = urlComponents?.url else { throw networkError.unknownError }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginData = LoginRequestDTO(email: email, password: password)
        
        do {
            request.httpBody = try JSONEncoder().encode(loginData)
        } catch {
            throw error
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            if httpResponse.statusCode == 401 {
                let detailData = try JSONDecoder().decode(LoginErrorDetail.self, from: data)
                let detail = detailData.detail
                if detail == "Неверная почта или пароль" {
                    throw networkError.invalidCredentials
                } else if detail == "Ваша почта не подтверждена и аккаунт не подтвержден модератором" {
                    throw networkError.unverifiedCredentials
                }
            } else {
                throw networkError.invalidServerResponseCode(httpResponse.statusCode)
            }
        }
        
        let userDTO = try JSONDecoder().decode(UserDTO.self, from: data)
        return userDTO
    }
}
