import Foundation

struct Category: Codable, Identifiable {
    let id: Int
    let category: String
    let createdAt: String
    let updatedAt: String
    let deletedAt: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "CategoryId"
        case category = "Category"
        case createdAt = "CreatedAt"
        case updatedAt = "UpdatedAt"
        case deletedAt = "DeletedAt"
    }
}

struct CategoryResponse: Codable {
    let data: [Category]
    let totalData: Int
    let totalPage: Int
    
    private enum CodingKeys: String, CodingKey {
        case data
        case totalData = "total_data"
        case totalPage = "total_page"
    }
}

enum NetworkError: Error {
    case badURL
    case requestFailed
    case decodingError
    case noToken
}

struct CategoryByIdResponse: Codable{
    let data : Category
}

class CategoryService {
    private let session = URLSession.shared
    
    func fetchCategories(page: Int, perPage: Int, completion: @escaping (Result<CategoryResponse, NetworkError>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(.noToken))
            return
        }
        
        guard let url = BaseURL.url(for:"category/?keyword=&page=\(page)&per_page=\(perPage)") else {
            completion(.failure(.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
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
                let categoryResponse = try JSONDecoder().decode(CategoryResponse.self, from: data)
                completion(.success(categoryResponse))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchCategoriesDetail(categoryId: Int, completion: @escaping (Result<CategoryByIdResponse, NetworkError>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(.noToken))
            return
        }
        
        
        guard let url = BaseURL.url(for:"category/detail?category_id=\(categoryId)") else {
            completion(.failure(.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
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
                let categoryResponse = try JSONDecoder().decode(CategoryByIdResponse.self, from: data)
                completion(.success(categoryResponse))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    
}
