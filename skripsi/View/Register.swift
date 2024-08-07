//
//  Register.swift
//  skripsi
//
//  Created by Laode Saady on 31/08/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @StateObject private var loginVM = LoginViewModel()
    @State private var showLoginView = false
    var body: some View {
        ZStack(alignment:.top) {
            Image("bg")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea(edges: .all)
            
            VStack(alignment:.leading,spacing: 10) {
                Text("Username")
                    .padding(.horizontal)
                    .foregroundColor(Color("login-text"))
                    .font(.system(size:19, weight: .semibold, design: .default))
                    .padding(.top,20)
                    .padding(.bottom,8)
                HStack{
                    Image(systemName: "person")
                        .padding(.horizontal)
                    TextField("Username", text: $viewModel.username)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal)
                        .padding(.leading,-20)
                    
                }
                .padding(.bottom,20)
                Text("Email")
                    .padding(.horizontal)
                    .foregroundColor(Color("login-text"))
                    .font(.system(size:19, weight: .semibold, design: .default))
                    .padding(.bottom,8)
                HStack{
                    Image(systemName: "mail")
                        .padding(.horizontal)
                    TextField("Email", text: $viewModel.email)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal)
                        .padding(.leading,-20)
                }
                .padding(.bottom,20)
                Text("Password")
                    .padding(.horizontal)
                    .foregroundColor(Color("login-text"))
                    .font(.system(size:19, weight: .semibold, design: .default))
                    .padding(.bottom,8)
                HStack{
                    Image(systemName: "lock")
                        .padding(.horizontal)
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal)
                        .padding(.leading,-20)
                }
                .padding(.bottom,20)
                Text("Confirm Password")
                    .padding(.horizontal)
                    .foregroundColor(Color("login-text"))
                    .font(.system(size:19, weight: .semibold, design: .default))
                    .padding(.bottom,8)
                HStack{
                    Image(systemName: "lock")
                        .padding(.horizontal)
                    SecureField("Password", text: $viewModel.confirmPassword)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal)
                        .padding(.leading,-20)
                }
                .padding(.bottom,20)
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.register()
                    }) {
                        Text("Sign In                                                      ")
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(15)
                            .shadow(radius: 2)
                    }
                    .padding(.bottom, 10)
                    Spacer()
                }
                .padding(.horizontal)
                HStack{
                    Spacer()
                    Text("Or With")
                        .foregroundStyle(.gray)
                    Spacer()
                }
                .padding(.bottom, 10)
                HStack {
                    Spacer()
                    Button(action: {
//                        loginVM.login()
                    }) {
                        HStack {
                            Image("goggle")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Register With Google")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        //                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                    }
                    .padding(.bottom, 20)
                    Spacer()
                }
                .padding(.horizontal)

            }
            .padding()
            .background(Color.white)
            .cornerRadius(35)
            .padding([.leading,.trailing],20)
            .padding(.top,70)
            
            VStack {
                Spacer()
                Text("Bank Soal .")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 48, weight: .black, design: .default))
                    .padding(.bottom,90)
                //                Spacer()
            }
            
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
