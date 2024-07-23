import Foundation

protocol Endpoint {
    var baseURL: URL? { get }
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
}

protocol RequestDTO: Encodable {}
protocol ResponseDTO: Decodable {}
