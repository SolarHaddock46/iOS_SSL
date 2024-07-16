import Foundation

final class RegisterSecondWorker {
    
    static func postRegister(requestData: RegisterRequest) async throws -> RegisterResponse {
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

        let jsonData = try JSONEncoder().encode(requestData)
        multipartData.append(jsonData, forKey: "data", fileName: "data.json", mimeType: "application/json")

        multipartData.append(requestData.firstName, forKey: "first_name")
        multipartData.append(requestData.lastName, forKey: "last_name")
        multipartData.append(requestData.fatherName, forKey: "father_name")
        multipartData.append(requestData.telegram, forKey: "telegram")
        multipartData.append(requestData.email, forKey: "email")
        multipartData.append(requestData.password1, forKey: "password1")
        multipartData.append(requestData.password2, forKey: "password2")
        multipartData.append("\(requestData.hsePass)", forKey: "hse_pass")
        multipartData.append("\(requestData.acceptConditions)", forKey: "accept_conditions")

        if let imageData = requestData.imageData {
            multipartData.append(imageData, forKey: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        }

        request.setValue(multipartData.contentType(), forHTTPHeaderField: "Content-Type")
        request.httpBody = multipartData.finish()

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            let statusCode = httpResponse.statusCode
            
            if statusCode != HTTPCode.created {
                if statusCode == HTTPCode.badRequest { 
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
                    throw NetworkError.invalidServerResponseCode(statusCode)
                }
            }
        }

        let userDTO = try JSONDecoder().decode(RegisterResponse.self, from: data)
        return userDTO
    }
}
