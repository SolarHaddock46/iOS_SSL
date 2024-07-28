import Foundation

class SSLNetworkService {
    static let shared = SSLNetworkService()
    
    private init() {}
    
    func request<Request: Encodable, Response: Decodable>(endpoint: Endpoint, requestDTO: Request) async throws -> Response {
        guard let baseURL = endpoint.baseURL else {
            throw NetworkError.internalError
        }
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = endpoint.path
        
        guard let url = urlComponents?.url else {
            throw NetworkError.unknownError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        
        if let headers = endpoint.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if endpoint.method != HTTPMethod.get {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(requestDTO)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            let statusCode = httpResponse.statusCode
            
            if !(200...299).contains(statusCode) {
                if statusCode == HTTPCode.badRequest {
                    if endpoint is RegisterEndpoint {
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
                    }
                } else if statusCode == HTTPCode.unauthorized {
                    if endpoint is LoginEndpoint {
                        let detailData = try JSONDecoder().decode(LoginErrorDetail.self, from: data)
                        let detail = detailData.detail
                        
                        if detail == VerbalServerResponse.invalidCredentials {
                            throw NetworkError.invalidCredentials
                        } else if detail == VerbalServerResponse.unverifiedCredentials {
                            throw NetworkError.unverifiedCredentials
                        }
                    }
                } else {
                    throw NetworkError.invalidServerResponseCode(statusCode)
                }
            }
        }
        
        let responseDTO = try JSONDecoder().decode(Response.self, from: data)
        return responseDTO
    }
}
