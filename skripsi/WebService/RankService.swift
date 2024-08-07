//
//  RankService.swift
//  skripsi
//
//  Created by Laode Saady on 16/09/24.
//

import Foundation

struct RankRequest: Codable {
    let user_id: Int
    let soal_id: Int
    let category_id: Int
    let next: Bool
}

struct RankResponse: Codable {
    let status: String
    let data: String?
}

struct PointResponse: Codable {
    let status: String
    let data: PointData
}

struct PointData: Codable {
    let point: Int
}

struct CheckData: Codable {
    let RangkingId: Int
    let UserId: Int
    let SoalId: Int
    let CategoryId: Int
    let Next: Bool
}
struct RankResponseCheck: Decodable {
    let status: String
    let data: String?
}

struct Rank: Codable {
    let user_id: Int
    let point: Int
    let username: String
    let profile: String
}


class RankService {
    static let shared = RankService()
    private let session = URLSession.shared
    enum NetworkError: Error {
        case noToken
        case badURL
        case requestFailed
        case decodingError
    }
    enum UserNetworkError: Error {
        case noToken
        case invalidResponse
    }

    // Function to create a rank
    func createRank(userId: Int, categoryId: Int, soalId: Int, next: Bool, completion: @escaping (Result<RankResponse, Error>) -> Void) {
        // Retrieve the token from UserDefaults
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(UserNetworkError.noToken))
            return
        }

        // Create the URL and request
        guard let url = BaseURL.url(for: "rank/create") else {
            completion(.failure(UserNetworkError.invalidResponse))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"  // Use POST for creating resources
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create the request body with rank details
        let body = RankRequest(user_id: userId, soal_id: soalId,category_id: categoryId,next: next)

        do {
            // Encode the request body to JSON
            let requestBody = try JSONEncoder().encode(body)
            request.httpBody = requestBody
        } catch {
            completion(.failure(error))
            return
        }

        // Create a data task to send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle any network errors
            if let error = error {
                completion(.failure(error))
                return
            }

            // Check for a valid HTTP response
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                completion(.failure(UserNetworkError.invalidResponse))
                return
            }

            do {
                // Decode the response data into RankResponse
                let decoder = JSONDecoder()
                let rankResponse = try decoder.decode(RankResponse.self, from: data)
                completion(.success(rankResponse))
            } catch {
                completion(.failure(error))
            }
        }

        // Start the data task
        task.resume()
    }
    // Function to fetch user points
    func fetchUserPoints(userId: Int, completion: @escaping (Result<PointResponse, Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(UserNetworkError.noToken))
            return
        }

        let url = BaseURL.url(for: "rank/point?user_id=\(userId)")!
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

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(PointResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchCheckRank(userId: Int, soalId: Int, categoryId: Int, completion: @escaping (Result<CheckData, Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(UserNetworkError.noToken))
            return
        }

        let url = BaseURL.url(for: "rank/check?user_id=\(userId)&soal_id=\(soalId)&category_id=\(categoryId)")!
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
            do {
                // Decode the response data into CheckRespon
                let decoder = JSONDecoder()
                let checkResponse = try decoder.decode(CheckData.self, from: data)
                completion(.success(checkResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func updateRank(userId: Int, soalId: Int, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        // URL endpoint for updating rank
        let urlString = "http://localhost:8080/rank/update?user_id=\(userId)&soal_id=\(soalId)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET" // Using GET method as per your specification
        
        session.dataTask(with: request) { data, response, error in
            // Handle request error
            if let error = error {
                completion(.failure(.requestFailed))
                print("Request error: \(error)") // Log the error for debugging
                return
            }
            
            // Check for a valid HTTP response with status code 200
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.requestFailed))
                return
            }
            
            // Ensure data is not nil
            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            
            do {
                // Decode response JSON
                let jsonResponse = try JSONDecoder().decode(RankResponse.self, from: data)
                
                // Check if the response status is OK
                if jsonResponse.status == "OK" {
                    // Check the 'data' field for a success message
                    if let dataMessage = jsonResponse.data, dataMessage.contains("Berhasil update ranking") {
                        completion(.success(true)) // Return success
                    } else {
                        completion(.success(false)) // Return false if the message doesn't indicate success
                    }
                } else {
                    completion(.failure(.requestFailed)) // If the status is not OK, return failure
                }
            } catch {
                completion(.failure(.decodingError))
                print("Decoding error: \(error)") // Log the error for debugging
            }
        }.resume()
    }

    func getRankList(completion: @escaping (Result<[Rank], Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(UserNetworkError.noToken))
            return
        }

        let url = BaseURL.url(for: "rank/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
         
        
         let task = session.dataTask(with: request) { data, response, error in
             if let error = error {
                 completion(.failure(error))
                 return
             }
             
             guard let data = data else {
                 completion(.failure(NetworkError.requestFailed))
                 return
             }
             
             do {
                 let decoder = JSONDecoder()
                 let rankList = try decoder.decode([Rank].self, from: data)
                 completion(.success(rankList))
             } catch {
                 completion(.failure(NetworkError.decodingError))
             }
         }
         
         task.resume()
     }
}
