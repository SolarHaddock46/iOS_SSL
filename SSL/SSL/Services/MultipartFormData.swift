import Foundation

class MultipartFormData {
    
    private let boundary: String
    private var data: Data

    init() {
        self.boundary = UUID().uuidString
        self.data = Data()
    }

    func append(_ value: String, forKey key: String) {
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(value)\r\n".data(using: .utf8)!)
    }

    func append(_ data: Data, forKey key: String, fileName: String, mimeType: String) {
        self.data.append("--\(boundary)\r\n".data(using: .utf8)!)
        self.data.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        self.data.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        self.data.append(data)
        self.data.append("\r\n".data(using: .utf8)!)
    }

    func finish() -> Data {
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return data
    }

    func contentType() -> String {
        return "multipart/form-data; boundary=\(boundary)"
    }
}
