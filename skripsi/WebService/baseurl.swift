//
//  baseurl.swift
//  skripsi
//
//  Created by Laode Saady on 17/09/24.
//

import Foundation

// A struct to manage the base URL and endpoints
struct BaseURL {
    // Define your base URL
    static let base = "https://3r1djzn5-8080.asse.devtunnels.ms"
    

    // Helper function to build full URLs from path components
    static func url(for endpoint: String) -> URL? {
        return URL(string: "\(base)/\(endpoint)")
    }
}
