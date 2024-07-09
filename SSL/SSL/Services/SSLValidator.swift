import Foundation

class SSLValidator {
    static func emailIsValid(email: String?) -> Bool {
        guard let email = email else { return false }
        let emailPattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$"
        return email.range(of: emailPattern, options: .regularExpression) != nil
    }
    
    static func nameIsValid(name: String?) -> Bool {
        guard let name = name else { return false }
        let namePattern = "^[a-zA-ZА-Яа-я\\s]{1,150}$"
        return name.range(of: namePattern, options: .regularExpression) != nil
    }
    
    static func telegramIsValid(telegram: String?) -> Bool {
        guard let telegram = telegram else { return false }
        let telegramPattern = "^(?![^@]*@)[a-zA-Z0-9_]{5,100}$"
        return telegram.range(of: telegramPattern, options: .regularExpression) != nil
    }
}
