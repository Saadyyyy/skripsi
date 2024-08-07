//
//  UserDetail.swift
//  skripsi
//
//  Created by Laode Saady on 17/09/24.
//

import SwiftUI

struct UserDetailView: View {
    @StateObject private var userVM = UserViewModel()
    @StateObject private var rankVM = RankViewModel()
    let userId: Int

    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea(edges: .all)
            VStack{
                if userVM.isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if let user = userVM.user {
                    VStack {
                        ZStack{
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                                .frame(width: 155, height: 155)
                            AsyncImage(url: URL(string: user.profile)) { image in
                                image.resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.top,70)
                        .padding()
                        
                        Text(user.username)
                            .font(.system(size: 40, weight: .heavy, design: .default))
                            .foregroundStyle(.white)
                            .padding(.leading, 5)
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text("\(rankVM.userPoints)") // Display user points
                                    .font(.system(size: 25, weight: .bold)) // Adjust text style
                                    .foregroundColor(.yellow)
                            }
                            .frame(width: 150, height: 40)
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5)
                        }
                        Spacer()
                        
                        Text("Total Category")
                    
                } else if let error = userVM.error {
                    Text("Error: \(error.localizedDescription)")
                        .foregroundColor(.red)
                        .padding()
                }
            }
          
        }
        .onAppear {
            if userVM.user == nil && !userVM.isLoading {
                userVM.fetchUserDetail(userId: userId)
                rankVM.fetchUserPoints(userId: userId)
            }
        }
        .navigationTitle("My Profile")
                .navigationBarTitleDisplayMode(.inline)
                .padding()
                .foregroundColor(.white)
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(userId: 13)
    }
}
