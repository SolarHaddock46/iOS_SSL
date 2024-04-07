import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}

final class LoginAPIManager {
    static func postLogin(email: String, password: String, completion: @escaping (Result<UserDTO?, Error>) -> Void) {
        let baseURL = URL(string: "https://ssl.smalyu.ru")!
        let apiRoutes = APIRoutes()
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = apiRoutes.loginRoute
        urlComponents?.queryItems = [URLQueryItem(name: "email", value: email),
                                     URLQueryItem(name: "password", value: password)]
        
        guard let url = urlComponents?.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginData = LoginRequest(email: email, password: password)
               
        do {
            request.httpBody = try JSONEncoder().encode(loginData)
        } catch {
            completion(.failure(error))
            return
        }
       
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                completion(.failure(NSError(domain: "Invalid response code", code: httpResponse.statusCode, userInfo: nil)))
                return
            }
            
            do {
                let userDTO = try JSONDecoder().decode(UserDTO.self, from: data)
                completion(.success(userDTO))
            } catch {
                completion(.failure(error))
            }
        }
       
        task.resume()
    }
}
