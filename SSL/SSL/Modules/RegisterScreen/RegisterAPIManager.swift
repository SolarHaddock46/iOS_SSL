import Foundation

struct RegisterErrorDetail: Codable {
    struct Errors: Codable {
        let email: [String]?
        let password: [String]?
    }

    let errors: Errors
}

struct UserRegisterDTO: Codable {
    let first_name: String
    let last_name: String
    let father_name: String
    let telegram: String
    let email: String
    let image: String?
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

struct RegisterRequestImagelessDTO: Codable {
    let first_name: String
    let last_name: String
    let father_name: String
    let telegram: String
    let email: String
    let password1: String
    let password2: String
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
        
        guard let url = urlComponents?.url else { throw networkError.unknownError }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let registerData: Encodable
        if !image.isEmpty {
            registerData = RegisterRequestDTO(first_name: first_name, last_name: last_name, father_name: father_name, telegram: telegram, email: email, password1: password1, password2: password2, image: image, hse_pass: hse_pass, accept_conditions: accept_conditions)
        } else {
            registerData = RegisterRequestImagelessDTO(first_name: first_name, last_name: last_name, father_name: father_name, telegram: telegram, email: email, password1: password1, password2: password2, hse_pass: hse_pass, accept_conditions: accept_conditions)
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(registerData)
        } catch {
            throw error
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 201 {
            if httpResponse.statusCode == 400 {
                let detailData = try JSONDecoder().decode(RegisterErrorDetail.self, from: data)
                if let emailDetails = detailData.errors.email, !emailDetails.isEmpty {
                    if emailDetails[0] == "пользователь с таким Адрес электронной почты уже существует." {
                        throw networkError.emailAlreadyExists
                    }
                }
                if let passwordDetails = detailData.errors.password, !passwordDetails.isEmpty {
                    if passwordDetails[0] == "Введённый пароль слишком широко распространён." {
                        throw networkError.weakPassword
                    }
                }
            } else {
                throw networkError.invalidServerResponseCode(httpResponse.statusCode)
            }
        }
        
        let userDTO = try JSONDecoder().decode(UserRegisterDTO.self, from: data)
        return userDTO
    }
}
