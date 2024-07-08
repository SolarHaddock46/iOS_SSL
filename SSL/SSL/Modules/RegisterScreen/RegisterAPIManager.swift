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

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        let registerData = RegisterRequestDTO(first_name: first_name, last_name: last_name, father_name: father_name, telegram: telegram, email: email, password1: password1, password2: password2, hse_pass: hse_pass, accept_conditions: accept_conditions)
        let jsonData = try JSONEncoder().encode(registerData)
        appendFormData(&body, boundary: boundary, name: "data", data: jsonData)

        appendFormData(&body, boundary: boundary, name: "first_name", data: first_name.data(using: .utf8)!)
        appendFormData(&body, boundary: boundary, name: "last_name", data: last_name.data(using: .utf8)!)
        appendFormData(&body, boundary: boundary, name: "father_name", data: father_name.data(using: .utf8)!)
        appendFormData(&body, boundary: boundary, name: "telegram", data: telegram.data(using: .utf8)!)
        appendFormData(&body, boundary: boundary, name: "email", data: email.data(using: .utf8)!)
        appendFormData(&body, boundary: boundary, name: "password1", data: password1.data(using: .utf8)!)
        appendFormData(&body, boundary: boundary, name: "password2", data: password2.data(using: .utf8)!)
        appendFormData(&body, boundary: boundary, name: "hse_pass", data: "\(hse_pass)".data(using: .utf8)!)
        appendFormData(&body, boundary: boundary, name: "accept_conditions", data: "\(accept_conditions)".data(using: .utf8)!)

        if let imageData = imageData {
            appendFormData(&body, boundary: boundary, name: "image", fileName: "image.jpg", data: imageData, mimeType: "image/jpeg")
        }

        appendBoundaryEnd(&body, boundary: boundary)
        request.httpBody = body

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

    private static func appendFormData(_ body: inout Data, boundary: String, name: String, data: Data) {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n".data(using: .utf8)!)
    }

    private static func appendFormData(_ body: inout Data, boundary: String, name: String, fileName: String, data: Data, mimeType: String) {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n".data(using: .utf8)!)
    }

    private static func appendBoundaryEnd(_ body: inout Data, boundary: String) {
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
    }
}
