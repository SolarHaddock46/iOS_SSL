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
}
