import Foundation

struct RegisterErrorDetail: Codable {
    struct Errors: Codable {
        let email: [String]?
        let password: [String]?
    }

    let errors: Errors
}
