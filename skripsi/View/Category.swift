//
//  Category.swift
//  skripsi
//
//  Created by Laode Saady on 31/08/24.
//

import SwiftUI

struct CategoryListView: View {
    @ObservedObject var viewModel = CategoryViewModel()
    @StateObject private var loginVM = LoginViewModel()
    
    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                List(viewModel.categories) { category in
                    Text(category.category)
                }
                .onAppear {
                    viewModel.getAllCategories(page: 1, perPage: 10) // Panggil fungsi untuk memuat kategori saat tampilan muncul
                }
            } else {
                LoginView() // Ganti dengan navigasi atau view login yang sesuai
            }
        }
        .onAppear {
            viewModel.checkAuthStatus()
        }
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
