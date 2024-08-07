import Foundation

class LoginViewModel: ObservableObject {
    @Published var username_or_email: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated = false
    private let tokenKey = "authToken"

    init() {
        checkAuthStatus()
    }
    
    func login() {
        let defaults = UserDefaults.standard
        LoginService().login(usernameOrEmail: username_or_email, password: password) { result in
            switch result {
            case .success(let token):
                print("Received token: \(token)")
                defaults.setValue(token, forKey: self.tokenKey)
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
            case .failure(let error):
                defaults.removeObject(forKey: self.tokenKey)
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                }
                print("Login failed: \(error.localizedDescription)")
            }
        }
    }

    func logout() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: tokenKey)
        DispatchQueue.main.async {
            self.isAuthenticated = false
        }
    }

    func checkAuthStatus() {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: tokenKey), isTokenValid(token: token) {
            DispatchQueue.main.async {
                self.isAuthenticated = true
            }
        } else {
            defaults.removeObject(forKey: tokenKey) // Remove the expired token
            DispatchQueue.main.async {
                self.isAuthenticated = false
            }
        }
    }

    func decode(jwtToken: String) -> [String: Any]? {
        let segments = jwtToken.split(separator: ".")
        guard segments.count == 3 else {
            print("Invalid token format")
            return nil
        }

        let base64String = String(segments[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        let paddedLength = base64String.count + (4 - base64String.count % 4) % 4
        let paddedBase64 = base64String.padding(toLength: paddedLength, withPad: "=", startingAt: 0)

        guard let data = Data(base64Encoded: paddedBase64),
              let json = try? JSONSerialization.jsonObject(with: data, options: []),
              let payload = json as? [String: Any] else {
            print("Failed to decode payload")
            return nil
        }

        return payload
    }


    func isTokenValid(token: String) -> Bool {
        guard let payload = decode(jwtToken: token),
              let exp = payload["exp"] as? TimeInterval else {
            return false
        }

        let expirationDate = Date(timeIntervalSince1970: exp)
        return expirationDate > Date()
    }

}
