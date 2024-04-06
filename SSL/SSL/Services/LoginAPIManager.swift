import Foundation

final class LoginAPIManager {
    static func postLogin(email: String, password: String) async throws -> UserDTO? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "ssl.smalyu.ru"
        urlComponents.path = "/api/users/auth/login/"
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters = ["email": email, "password": password]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch let error {
            throw error
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode(UserDTO.self, from: data)
        } catch let error {
            throw error
        }
    }
}



