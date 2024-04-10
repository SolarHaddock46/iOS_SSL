import Foundation

struct UserRegisterDTO: Codable {
    let firstName: String
    let secondName: String
    let fatherName: String
    let telegram: String
    let email: String
    let image: String
    let hsePass: Bool
}
