import Foundation

struct LoginEndpoint: Endpoint {
    var baseURL: URL? {
        return APIRoutes().baseURL
    }
    
    var path: String {
        return APIRoutes().loginRoute
    }
    
    var method: String {
        return HTTPMethod.post
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

struct LoginRequestDTO: Encodable {
    let email: String
    let password: String
}

struct LoginResponseDTO: Codable {
    let email: String
    let password: String
    let tokens: Tokens
}

struct Tokens: Codable {
    let access: String
    let refresh: String
}

struct LoginErrorDetail: Codable {
    let detail: String
}
