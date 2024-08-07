import Foundation

struct Userr: Codable, Identifiable {
    let id: Int
    let username: String
    let role: Int
    let profile: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "user_id"      // Maps `user_id` in the JSON to `id`
        case username
        case role
        case profile
    }
}

struct UserResponse: Decodable {
    let status: String
    let data: Userr
    // CodingKeys are not strictly necessary here since keys match exactly
}



enum UserNetworkError: Error {
    case badURL
    case requestFailed
    case decodingError
    case noToken
}



class UserService {
    func fetchUserDetail(userId: Int, completion: @escaping (Result<UserResponse, Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(UserNetworkError.noToken))
            return
        }
        let url = BaseURL.url(for:"user/detail?user_id=\(userId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            // Debugging: Print the raw JSON string
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response: \(jsonString)")
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(UserResponse.self, from: data)
                print("Decoded user data: \(response.data)")
                completion(.success(response))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}
