//
//  RegisterViewModel.swift
//  skripsi
//
//  Created by Laode Saady on 31/08/24.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    @Published var email: String = ""
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    private let userService = LoginService()
    
    func register() {
        let user = RegisterUser(username: username, password: password, email: email)
        if password != confirmPassword{
            self.alertTitle = "Error"
            self.alertMessage = "Password berbeda"
        }
        userService.registerUser(user: user) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    self?.alertTitle = "Success"
                    self?.alertMessage = "Berhasil membuat akun"
                case .failure(let error):
                    self?.alertTitle = "Error"
                    self?.alertMessage = "Gagal mendaftar: \(error.localizedDescription)"
                }
                self?.showAlert = true
            }
        }
    }
}
