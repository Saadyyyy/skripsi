//
//  listRank.swift
//  skripsi
//
//  Created by Laode Saady on 29/09/24.
//

import SwiftUI

struct RankListView: View {

    @ObservedObject var viewModel: RankViewModel

    var body: some View {
        ZStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading ranks...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else if viewModel.ranks.isEmpty {
                    Text("No ranks available")
                        .foregroundColor(.gray)
                } else {
                    List(viewModel.ranks.prefix(10), id: \.user_id) { rank in  // Limit to top 10
                        HStack {
                            ZStack {
                                Circle()
                                    .stroke(Color.black, lineWidth: 1)
                                    .frame(width: 62, height: 62)
                                
                                AsyncImage(url: URL(string: rank.profile)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(rank.username)
                                        .font(.system(size: 24, design: .default))
                                        .fontWeight(.semibold)
                                        .padding(.leading, 20)
                                }
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text("\(rank.point)")
                                        .font(.subheadline)
                                }
                                .padding(.leading, 20)
                            }
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(Color.yellow.opacity(0.2))
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Image(systemName: "trophy")
                                            .foregroundColor(.yellow)
                                            .font(.system(size: 24))
                                    )
                                Text("\(viewModel.ranks.firstIndex(where: { $0.user_id == rank.user_id })! + 1)")
                                    .font(.system(size: 24, design: .default))
                                    .foregroundColor(.black)
                                    
                            }
                            .padding(.trailing, 20)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .onAppear {
                viewModel.fetchRankList()
            }
            .navigationBarTitle("Rankings", displayMode: .inline)
            .background(.blue)
        }
    }
}

struct RankListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = RankViewModel()
        RankListView(viewModel: viewModel)
    }
}
