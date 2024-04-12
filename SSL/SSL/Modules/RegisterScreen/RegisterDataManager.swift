import Foundation

class RegisterDataManager {
    static let shared = RegisterDataManager()
    var firstName: String?
    var secondName: String?
    var fatherName: String?
    var image: String?
    var hsePass: Bool?
    var acceptConditions: Bool?
    
    private init(firstName: String? = nil, secondName: String? = nil, fatherName: String? = nil, hsePass: Bool? = nil, acceptConditions: Bool? = nil) {
        self.firstName = firstName
        self.secondName = secondName
        self.fatherName = fatherName
        self.hsePass = hsePass
        self.acceptConditions = acceptConditions
    }
}
