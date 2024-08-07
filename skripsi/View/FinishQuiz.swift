//
//  FinishQuiz.swift
//  skripsi
//
//  Created by Laode Saady on 17/09/24.
//

import SwiftUI

struct FinishQuiz: View {
    @StateObject private var categoryVM = CategoryViewModel()
    @StateObject private var soalVM = SoalViewModel()
    
    var selectedCategoryId: Int  // Pastikan ini di-pass dari halaman sebelumnya
    var body: some View {
        ZStack {
            // Background Image
            Image("bg")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea(edges: .all)
            
            VStack {
                Spacer()
                // Display Category Name
                Text(categoryVM.category)
                    .font(.system(size: 23, weight: .medium, design: .default))
                    .fontWeight(.heavy)
                    .padding(.vertical)
                    .foregroundColor(.white)
                
                // Display Total Quiz Count for the Category
                Text("\(soalVM.totalDataByCategory[selectedCategoryId] ?? 0) SOAL")
                    .font(.system(size: 24, weight: .medium, design: .default))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                Image("finish")
                
                // Congratulation Text
                Text("Congrats! The quiz is done")
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                
                // Finish Button
                Button(action: {
                    // Handle button action (e.g., navigate back to home)
                }) {
                    Text("Finish")
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .foregroundColor(Color("boardingText"))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(50)
                        .shadow(radius: 2)
                }
                .padding(.bottom, 50)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
        .onAppear {
            // Fetch category detail for the selected category
            categoryVM.getCategoriesDetail(categoryId: selectedCategoryId)
            // Fetch total quiz for the selected category
            soalVM.fetchSoal(forCategory: selectedCategoryId)
        }
    }
}

struct FinishQuiz_Previews: PreviewProvider {
    static var previews: some View {
        FinishQuiz(selectedCategoryId: 1)  // Example category ID
    }
}
