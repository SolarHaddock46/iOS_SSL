import Foundation

struct RegisterRequest: Codable {
    let firstName: String
    let lastName: String
    let fatherName: String
    let telegram: String
    let email: String
    let password1: String
    let password2: String
    let hsePass: Bool
    let acceptConditions: Bool
    let imageData: Data?
}

struct RegisterResponse: Codable {
    let firstName: String
    let lastName: String
    let fatherName: String
    let telegram: String
    let email: String
    let image: String?
    let hsePass: Bool
}

struct RegisterErrorDetail: Codable {
    struct Errors: Codable {
        let email: [String]?
        let password: [String]?
    }

    let errors: Errors
}
