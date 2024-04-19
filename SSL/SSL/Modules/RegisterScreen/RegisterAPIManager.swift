import Foundation

struct RegisterErrorDetail: Codable {
    struct Errors: Codable {
        let email: [String]
    }

    let errors: Errors
}

struct UserRegisterDTO: Codable {
    let first_name: String
    let last_name: String
    let father_name: String
    let telegram: String
    let email: String
    let image: String
    let hse_pass: Bool
}

struct RegisterRequestDTO: Codable {
    let first_name: String
    let last_name: String
    let father_name: String
    let telegram: String
    let email: String
    let password1: String
    let password2: String
    let image: String
    let hse_pass: Bool
    let accept_conditions: Bool
}

final class RegisterAPIManager {
    static func postRegister(first_name: String, last_name: String, father_name: String, telegram: String, email: String, password1: String, password2: String, image: String, hse_pass: Bool, accept_conditions: Bool) async throws -> UserRegisterDTO {
        guard let baseURL = URL(string: "https://ssl.smalyu.ru") else { throw NetworkError.internalError }
        let apiRoutes = APIRoutes()
        let networkError = NetworkError.self
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = apiRoutes.registerRoute
        
        var queryItems = [
            URLQueryItem(name: "first_name", value: first_name),
            URLQueryItem(name: "last_name", value: last_name),
            URLQueryItem(name: "father_name", value: father_name),
            URLQueryItem(name: "telegram", value: telegram),
            URLQueryItem(name: "email", value: email),
            URLQueryItem(name: "password1", value: password1),
            URLQueryItem(name: "password2", value: password2),
            URLQueryItem(name: "image", value: image),
            URLQueryItem(name: "hse_pass", value: String(hse_pass)),
            URLQueryItem(name: "accept_conditions", value: String(accept_conditions))
        ]
    
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { throw networkError.unknownError }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let registerData = RegisterRequestDTO(first_name: first_name, last_name: last_name, father_name: father_name, telegram: telegram, email: email, password1: password1, password2: password2, image: image, hse_pass: hse_pass, accept_conditions: accept_conditions)
        
        do {
            request.httpBody = try JSONEncoder().encode(registerData)
        } catch {
            throw error
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 201 {
            if httpResponse.statusCode == 400 {
                let detailData = try JSONDecoder().decode(RegisterErrorDetail.self, from: data)
                let emailDetails = detailData.errors.email
                let detail = emailDetails[0]
                if detail == "пользователь с таким Адрес электронной почты уже существует." {
                    throw networkError.emailAlreadyExists
                }
            } else {
                throw networkError.invalidServerResponseCode(httpResponse.statusCode)
            }
        }
        
        let userDTO = try JSONDecoder().decode(UserRegisterDTO.self, from: data)
        return userDTO
        
    }
}


