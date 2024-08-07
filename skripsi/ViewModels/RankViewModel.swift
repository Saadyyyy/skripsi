//
//  RankViewModel.swift
//  skripsi
//
//  Created by Laode Saady on 16/09/24.
//

import SwiftUI
import Combine

class RankViewModel: ObservableObject {
    @Published var userPoints: Int = 0
    @Published var rankResponse: RankResponse?
    @Published var checkData: CheckData?
    @Published var rankStatus: String = ""
    @Published var ranks: [Rank] = []
    @Published var isLoading: Bool = false
    
        @Published var errorMessage: String?
        
        private let rankService = RankService()
        
        func createRank(userId: Int, categoryId: Int, soalId: Int, next: Bool) {
            rankService.createRank(userId: userId, categoryId: categoryId, soalId: soalId, next: next) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self?.rankResponse = response
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
        }

    func fetchUserPoints(userId: Int) {
        rankService.fetchUserPoints(userId: userId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let pointResponse):
                    self.userPoints = pointResponse.data.point
                    print("User points fetched: \(self.userPoints)")
                case .failure(let error):
                    print("Error fetching user points: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchCheckRank(userId: Int, soalId: Int, categoryId: Int) {
        rankService.fetchCheckRank(userId: userId, soalId: soalId, categoryId: categoryId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let checkResponse):
                    self.checkData = checkResponse
                    
                    print("Check response: \(self.checkData)") 
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Error fetching check rank: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updateRank(userId: Int, soalId: Int) {
        rankService.updateRank(userId: userId, soalId: soalId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isSuccessful):
                    // If the result is true, set a success message; otherwise, set a failure message
                    self.rankStatus = isSuccessful ? "Rank update successful" : "Failed to update rank"
                case .failure(let error):
                    // Set the rank status to an error message if the operation fails
                    self.rankStatus = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // Function to get rank list
       func fetchRankList() {
           self.isLoading = true
           rankService.getRankList { [weak self] result in
               DispatchQueue.main.async {
                   self?.isLoading = false
                   switch result {
                   case .success(let rankList):
                       self?.ranks = rankList
                   case .failure(let error):
                       self?.errorMessage = error.localizedDescription
                   }
               }
           }
       }
}
