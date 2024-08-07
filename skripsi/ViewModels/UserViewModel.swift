//
//  UserViewModel.swift
//  skripsi
//
//  Created by Laode Saady on 17/09/24.
//
import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var user: Userr?
      
      @Published var error: Error?
      @Published var isLoading = false

      private var cancellables = Set<AnyCancellable>()
    
    func fetchUserDetail(userId: Int) {
        isLoading = true
        UserService().fetchUserDetail(userId: userId) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let userResponse):
                    self.user = userResponse.data
                    print("Fetched user: \(self.user)")
                case .failure(let error):
                    self.error = error
                    print("Error fetching user: \(error.localizedDescription)") // Debugging
                }
            }
        }
    }
    

}
