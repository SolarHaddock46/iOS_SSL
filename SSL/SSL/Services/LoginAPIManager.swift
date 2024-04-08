import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct ErrorDetail: Codable {
    let detail: String
}

final class LoginAPIManager {
    static func postLogin(email: String, password: String) async throws -> UserDTO {
        let baseURL = URL(string: "https://ssl.smalyu.ru")!
        let apiRoutes = APIRoutes()
        let networkError = NetworkError.self
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = apiRoutes.loginRoute
        urlComponents?.queryItems = [URLQueryItem(name: "email", value: email),
                                     URLQueryItem(name: "password", value: password)]
        
        guard let url = urlComponents?.url else { throw networkError.unknownError }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginData = LoginRequest(email: email, password: password)
               
        do {
            request.httpBody = try JSONEncoder().encode(loginData)
        } catch {
            throw error
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            if httpResponse.statusCode == 401 {
                let detailData = try JSONDecoder().decode(ErrorDetail.self, from: data)
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
