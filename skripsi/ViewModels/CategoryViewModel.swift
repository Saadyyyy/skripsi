//
//  CategoryViewModel.swift
//  skripsi
//
//  Created by Laode Saady on 31/08/24.
//

import Foundation
import Combine

class CategoryViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var isAuthenticated: Bool = false
    @Published var totalData = 0
    @Published var selectedCategory: Category?
    @Published var category = ""
    
    private let tokenKey = "authToken"
    
    func getAllCategories(page: Int, perPage: Int) {
        CategoryService().fetchCategories(page: page, perPage: perPage) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.categories = response.data
                    self.totalData = response.totalData
                    print("Total Data in ViewModel: \(self.totalData)") // Log the total data in ViewModel
                }
            case .failure(let error):
                print("Fetching categories failed: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                }
            }
        }

    }
    func getCategoriesDetail(categoryId: Int) {
        CategoryService().fetchCategoriesDetail(categoryId: categoryId) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.category = response.data.category
                    print("Total Data in ViewModel: \(self.category)") // Log the total data in ViewModel
                }
            case .failure(let error):
                print("Fetching categories failed: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                }
            }
        }

    }
    

    func checkAuthStatus() {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: tokenKey) != nil {
            DispatchQueue.main.async {
                self.isAuthenticated = true
            }
        } else {
            DispatchQueue.main.async {
                self.isAuthenticated = false
            }
        }
    }
}
