//
//  SoalViewModel.swift
//  skripsi
//
//  Created by Laode Saady on 03/09/24.
//

import Foundation

class SoalViewModel: ObservableObject {
    @Published var soalList: [Soal] = []
    @Published var totalDataByCategory: [Int: Int] = [:]  // Menyimpan jumlah soal per kategori
    @Published var selectedSoalDetail: SoalDetail?  // Use this to store selected SoalDetail
    @Published var currentIndex = 0
    @Published var loginVM = LoginViewModel()  // Tambahkan LoginViewModel
    @Published var selectedCategoryId: Int = 0
    
    private let service = SoalService()
    
    var currentSoal: Soal? {
        if currentIndex < soalList.count {
            return soalList[currentIndex]
        }
        return nil
    }

    func fetchSoal(forCategory categoryId: Int) {
        // Jika pengguna sudah login, lanjutkan permintaan API
        service.fetchSoal(categoryId: categoryId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.soalList = response.data
                    self.totalDataByCategory[categoryId] = response.totalData
                    self.currentIndex = 0
                case .failure(let error):
                    print("Failed to fetch soal1: \(error)")
                }
            }
        }
    }

    func nextSoal() {
        // Assuming currentIndex is being updated properly
        if currentIndex < soalList.count {
            let soalId = soalList[currentIndex].id
            print("Fetching Soal ID: \(soalId)")
            service.fetchSoalById(soalId: soalId) { result in
                switch result {
                case .success(let soalResponse):
                    // Handle success
                    print("Fetched Soal: \(soalResponse)")
                case .failure(let error):
                    // Handle error
                    print("Error fetching soal2: \(error)")
                }
            }
            currentIndex += 1 // Increment index after fetching
        }
    }

    func previousSoal() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }
    
    func fetchSoalById(soalId: Int) {
        service.fetchSoalById(soalId: soalId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.selectedSoalDetail = response.data
                case .failure(let error):
                    print("Failed to fetch soal by ID: \(error)")
                }
            }
        }
    }
}
