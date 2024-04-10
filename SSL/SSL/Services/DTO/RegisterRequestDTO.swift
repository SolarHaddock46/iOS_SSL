import Foundation

struct RegisterRequestDTO: Codable {
    let firstName: String
    let secondName: String
    let fatherName: String?
    let telegram: String
    let email: String
    let password1: String
    let password2: String
    let image: String?
    let hsePass: Bool
    let acceptConditions: Bool
}
