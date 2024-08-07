//
//  SoalService.swift
//  skripsi
//
//  Created by Laode Saady on 03/09/24.
//

import Foundation

struct Soal: Codable, Identifiable {
    let id: Int
    let categoryId: Int
    let soal: String
    let jawabanA: String
    let jawabanB: String
    let jawabanC: String
    let jawabanD: String
    let jawabanBenar: String
    let createdAt: String
    let updatedAt: String?
    let deletedAt: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "SoalId"
        case categoryId = "CategoryId"
        case soal = "Soal"
        case jawabanA = "JawabanA"
        case jawabanB = "JawabanB"
        case jawabanC = "JawabanC"
        case jawabanD = "JawabanD"
        case jawabanBenar = "JawabanBenar"
        case createdAt = "CreatedAt"
        case updatedAt = "UpdatedAt"
        case deletedAt = "DeletedAt"
    }
}

struct SoalResponse: Codable {
    let data: [Soal]
    let totalData: Int
    
    private enum CodingKeys: String, CodingKey {
        case data
        case totalData = "total_data"
    }
}

struct SoalResponseDetail: Codable {
    let status: String
    let data: SoalDetail
}

struct SoalDetail: Codable {
    let soalId: Int
    let categoryId: Int
    let soal: String
    let jawabanA: String
    let jawabanB: String
    let jawabanC: String
    let jawabanD: String
    let jawabanBenar: String
    let createdAt: String
    let updatedAt: String?
    let deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case soalId = "SoalId"
        case categoryId = "CategoryId"
        case soal = "Soal"
        case jawabanA = "JawabanA"
        case jawabanB = "JawabanB"
        case jawabanC = "JawabanC"
        case jawabanD = "JawabanD"
        case jawabanBenar = "JawabanBenar"
        case createdAt = "CreatedAt"
        case updatedAt = "UpdatedAt"
        case deletedAt = "DeletedAt"
    }
}

class SoalService {

    private let session = URLSession.shared
    
    func fetchSoal(categoryId: Int, completion: @escaping (Result<SoalResponse, NetworkError>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(.noToken))
            return
        }
        
        guard let url =   BaseURL.url(for:"soal/?category_id=\(categoryId)")else {
            completion(.failure(.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            
            do {
                let soalResponse = try JSONDecoder().decode(SoalResponse.self, from: data)
                completion(.success(soalResponse))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }

    func fetchSoalById(soalId: Int, completion: @escaping (Result<SoalResponseDetail, Error>) -> Void) {
        enum NetworkError: Error {
            case badURL
            case requestFailed
            case decodingError
            case noToken
        }
        
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(NetworkError.noToken))
            return
        }
        
        guard let url = BaseURL.url(for:"soal/detail?soal_id=\(soalId)") else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }
            
            // Log the received data for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received JSON: \(jsonString)")
            }
            
            do {
                let decoder = JSONDecoder()
                let soalResponseDetail = try decoder.decode(SoalResponseDetail.self, from: data)
                completion(.success(soalResponseDetail))
            } catch {
                // Log the error to understand what went wrong
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

}

