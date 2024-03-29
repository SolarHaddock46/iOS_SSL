import Foundation
import Moya

enum APITarget {
    case login(email: String, password: String)
}

extension APITarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://ssl.smalyu.ru/api")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/users/auth/login/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .login(let email, let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
