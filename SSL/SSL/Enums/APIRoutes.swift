import Foundation

struct APIRoutes {
    let baseURL = URL(string: "https://ssl.smalyu.ru")
    let loginRoute: String = "/api/users/auth/login/"
    let registerRoute: String = "/api/users/auth/register/"
}
