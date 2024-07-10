import Foundation

final class RegisterAPIManager {
    
    static func postRegister(firstName: String, lastName: String, fatherName: String, telegram: String, email: String, password1: String, password2: String, imageData: Data?, hsePass: Bool, acceptConditions: Bool) async throws -> UserRegisterDTO {
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
        request.httpMethod = HTTPMethod.post

        let multipartData = MultipartFormData()

        let registerData = RegisterRequestDTO(firstName: firstName, lastName: lastName, fatherName: fatherName, telegram: telegram, email: email, password1: password1, password2: password2, hsePass: hsePass, acceptConditions: acceptConditions)
        let jsonData = try JSONEncoder().encode(registerData)
        multipartData.append(jsonData, forKey: "data", fileName: "data.json", mimeType: "application/json")

        multipartData.append(firstName, forKey: "first_name")
        multipartData.append(lastName, forKey: "last_name")
        multipartData.append(fatherName, forKey: "father_name")
        multipartData.append(telegram, forKey: "telegram")
        multipartData.append(email, forKey: "email")
        multipartData.append(password1, forKey: "password1")
        multipartData.append(password2, forKey: "password2")
        multipartData.append("\(hsePass)", forKey: "hse_pass")
        multipartData.append("\(acceptConditions)", forKey: "accept_conditions")

        if let imageData = imageData {
            multipartData.append(imageData, forKey: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        }

        request.setValue(multipartData.contentType(), forHTTPHeaderField: "Content-Type")
        request.httpBody = multipartData.finish()

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != HTTPCode.ok {
            if httpResponse.statusCode == HTTPCode.badRequest {
                let detailData = try JSONDecoder().decode(RegisterErrorDetail.self, from: data)
                if let emailDetails = detailData.errors.email, !emailDetails.isEmpty {
                    if emailDetails[0] == VerbalServerResponse.emailAlreadyExists {
                        throw NetworkError.emailAlreadyExists
                    }
                }
                if let passwordDetails = detailData.errors.password, !passwordDetails.isEmpty {
                    if passwordDetails[0] == VerbalServerResponse.weakPassword {
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
