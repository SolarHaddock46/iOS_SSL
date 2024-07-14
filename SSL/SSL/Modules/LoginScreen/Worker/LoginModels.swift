import Foundation

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
