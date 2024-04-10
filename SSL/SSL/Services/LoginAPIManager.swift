import Foundation

struct LoginErrorDetail: Codable {
    let detail: String
}

struct RegisterErrorDetail: Codable {
    struct Errors: Codable {
        let email: [String]
    }

    let errors: Errors
}

final class LoginAPIManager {
    static func postLogin(email: String, password: String) async throws -> UserDTO {
        guard let baseURL = URL(string: "https://ssl.smalyu.ru") else { throw NetworkError.internalError }
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
    
    static func postRegister(firstName: String, secondName: String, fatherName: String?, telegram: String, email: String, password1: String, password2: String, image: String?, hsePass: Bool, acceptConditions: Bool) async throws -> UserRegisterDTO {
        guard let baseURL = URL(string: "https://ssl.smalyu.ru") else { throw NetworkError.internalError }
        let apiRoutes = APIRoutes()
        let networkError = NetworkError.self
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = apiRoutes.registerRoute
        
        var queryItems = [
            URLQueryItem(name: "first_name", value: firstName),
            URLQueryItem(name: "second_name", value: secondName),
            URLQueryItem(name: "telegram", value: telegram),
            URLQueryItem(name: "email", value: email),
            URLQueryItem(name: "password1", value: password1),
            URLQueryItem(name: "password2", value: password2),
            URLQueryItem(name: "hse_pass", value: String(hsePass)),
            URLQueryItem(name: "accept_conditions", value: String(acceptConditions))
        ]
    
        if let fatherName = fatherName {
            queryItems.append(URLQueryItem(name: "father_name", value: fatherName))
        }
        
        if let image = image {
            queryItems.append(URLQueryItem(name: "image", value: image))
        }
        
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { throw networkError.unknownError }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let registerData = RegisterRequestDTO(firstName: firstName, secondName: secondName, fatherName: fatherName, telegram: telegram, email: email, password1: password1, password2: password2, image: image, hsePass: hsePass, acceptConditions: acceptConditions)
        
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
