//
//  LoginService.swift
//  skripsi
//
//  Created by Laode Saady on 31/08/24.
//

import Foundation
import Foundation

enum AuthenticationError: Error {
    case invalidCredentials
    case custom(errorMessage: String)
}

struct LoginRequestBody: Codable {
    let username_or_email: String
    let password: String
}

struct LoginResponseBody: Codable {
    let status: String
    let data: UserLoginData?
}

struct UserLoginData: Codable {
    let token: String
    let user: User
}

struct User: Codable {
    let userId: Int?
    let username: String?
    let password: String?
    let email: String?
    let role: Int?
    let profile: String?
    
    private enum CodingKeys: String, CodingKey {
        case userId = "UserId"
        case username = "Username"
        case password = "Password"
        case email = "Email"
        case role = "Role"
        case profile = "Profile"
    }
}

// Define the User struct for login response
struct LoginUser: Codable {
    let UserId: Int
    let Username: String
    let Password: String
    let Email: String
    let Role: Int
    let Profile: String
}

// Define the User struct for registration request
struct RegisterUser: Codable {
    let username: String
    let password: String
    let email: String
}

// Define response structures
struct RegisterResponse: Codable {
    let status: String
    let data: String?
    let error_message: String?
}

class LoginService {
    func login(usernameOrEmail: String, password: String, completion: @escaping (Result<String, AuthenticationError>) -> Void) {
        guard let url = BaseURL.url(for:"user/login") else {
            completion(.failure(.custom(errorMessage: "Invalid URL")))
            return
        }
        
        let body = LoginRequestBody(username_or_email: usernameOrEmail, password: password)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.custom(errorMessage: "Request error: \(error.localizedDescription)")))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.custom(errorMessage: "Invalid response from server")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.custom(errorMessage: "No data received")))
                return
            }
            
            do {
                let loginResponse = try JSONDecoder().decode(LoginResponseBody.self, from: data)
                guard let token = loginResponse.data?.token else {
                    completion(.failure(.invalidCredentials))
                    return
                }
                completion(.success(token))
            } catch {
                completion(.failure(.custom(errorMessage: "Decoding error: \(error.localizedDescription)")))
            }
        }.resume()
    }
    
    func registerUser(user: RegisterUser, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = BaseURL.url(for:"user/register") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
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
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
                if decodedResponse.status == "OK" {
                    completion(.success(decodedResponse.data ?? ""))
                } else {
                    let errorMessage = decodedResponse.error_message ?? "Unknown error"
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
