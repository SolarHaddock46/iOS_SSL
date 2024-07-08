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
    let hse_pass: Bool
    let accept_conditions: Bool
}

final class RegisterAPIManager {
    static func postRegister(first_name: String, last_name: String, father_name: String, telegram: String, email: String, password1: String, password2: String, imageData: Data?, hse_pass: Bool, accept_conditions: Bool) async throws -> UserRegisterDTO {
        let apiRoutes = APIRoutes()
        guard let baseURL = apiRoutes.baseURL else {
            throw NetworkError.internalError
        }

        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = apiRoutes.registerRoute

        guard let url = urlComponents?.url else {
            throw NetworkError.unknownError
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue

        let multipartData = MultipartFormData()

        let registerData = RegisterRequestDTO(first_name: first_name, last_name: last_name, father_name: father_name, telegram: telegram, email: email, password1: password1, password2: password2, hse_pass: hse_pass, accept_conditions: accept_conditions)
        let jsonData = try JSONEncoder().encode(registerData)
        multipartData.append(jsonData, forKey: "data", fileName: "data.json", mimeType: "application/json")

        multipartData.append(first_name, forKey: "first_name")
        multipartData.append(last_name, forKey: "last_name")
        multipartData.append(father_name, forKey: "father_name")
        multipartData.append(telegram, forKey: "telegram")
        multipartData.append(email, forKey: "email")
        multipartData.append(password1, forKey: "password1")
        multipartData.append(password2, forKey: "password2")
        multipartData.append("\(hse_pass)", forKey: "hse_pass")
        multipartData.append("\(accept_conditions)", forKey: "accept_conditions")

        if let imageData = imageData {
            multipartData.append(imageData, forKey: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        }

        request.setValue(multipartData.contentType(), forHTTPHeaderField: "Content-Type")
        request.httpBody = multipartData.finish()

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 201 {
            if httpResponse.statusCode == 400 {
                let detailData = try JSONDecoder().decode(RegisterErrorDetail.self, from: data)
                if let emailDetails = detailData.errors.email, !emailDetails.isEmpty {
                    if emailDetails[0] == "пользователь с таким Адрес электронной почты уже существует." {
                        throw NetworkError.emailAlreadyExists
                    }
                }
                if let passwordDetails = detailData.errors.password, !passwordDetails.isEmpty {
                    if passwordDetails[0] == "Введённый пароль слишком широко распространён." {
                        throw NetworkError.weakPassword
                    }
                }
            } else {
                throw NetworkError.invalidServerResponseCode(httpResponse.statusCode)
            }
        }

        let userDTO = try JSONDecoder().decode(UserRegisterDTO.self, from: data)
        return userDTO
    }
}
