import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}

final class LoginAPIManager {
    static func postLogin(email: String, password: String, completion: @escaping (Result<UserDTO?, Error>) -> Void) {
        let baseURL = URL(string: "https://ssl.smalyu.ru")!
        let apiRoutes = APIRoutes()
        let networkError = NetworkError.self
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = apiRoutes.loginRoute
        urlComponents?.queryItems = [URLQueryItem(name: "email", value: email),
                                     URLQueryItem(name: "password", value: password)]
        
        guard let url = urlComponents?.url else { return}
        
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
                completion(.failure(networkError.unknownError))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                if httpResponse.statusCode == 401 {
                    completion(.failure(networkError.invalidCredentials))
                } else {
                    completion(.failure(networkError.invalidServerResponseCode(httpResponse.statusCode)))
                }
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
