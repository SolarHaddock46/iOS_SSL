import Foundation

enum NetworkError: Error {
    case invalidCredentials
    case invalidServerResponseCode(Int)
    case unknownError
    case invalidUserDataFormat
    
}

extension NetworkError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .invalidCredentials:
            return NSLocalizedString("Invalid email or password", comment: "")
        case .invalidServerResponseCode(let statusCode):
            return String.localizedStringWithFormat(NSLocalizedString("Incorrect server response code: %@", comment: ""), statusCode)
        case .unknownError:
            return NSLocalizedString("Unknown error", comment: "")
        case .invalidUserDataFormat:
            return NSLocalizedString("Invalid user data format", comment: "")
        }
    }
}
