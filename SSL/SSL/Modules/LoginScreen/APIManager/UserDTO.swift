import Foundation

struct Tokens: Codable {
    let refresh: String
    let access: String
    let id: Int
}

struct UserDTO: Codable {
    let email: String
    let password: String
    let tokens: Tokens
}
