import SwiftUI

struct Dasboard: View {
    @StateObject private var loginVM = LoginViewModel()
    @StateObject private var categoryVM = CategoryViewModel()
    @StateObject private var soalVM = SoalViewModel()
    @StateObject private var userVM = UserViewModel()
    @StateObject private var rankVM = RankViewModel()
    
    @State private var isNavigating = false
    @State private var destination: Destination? = nil
    @State private var selectedCategoryId: Int = 1  // Default category
    @State private var userId: Int = 13
    enum Destination: Hashable {
        case categoryList
        case login
        case soalDetail
        case trophy
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea(edges: .all)

                // Header
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        if loginVM.isAuthenticated, let user = userVM.user {
                            NavigationLink(destination: UserDetailView(userId: user.id)) {
                                ZStack {
                                    // Lingkaran di luar
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                        .frame(width: 74, height: 74)
                                    
                                    AsyncImage(url: URL(string: user.profile)) { image in
                                        image.resizable()
                                            .scaledToFill()
                                            .frame(width: 70, height: 70)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 70, height: 70)
                                            .clipShape(Circle())
                                    }
                                }
                                .padding(.leading,10)
                                .padding(.top,15)
                                Text(user.username)
                                    .font(.system(size: 20, weight: .heavy, design: .default))
                                    .foregroundStyle(.white)
                                    .padding(.leading, 5)
                            }
                        } else {
                            NavigationLink(destination: LoginView()) {
                                Circle()
                                    .frame(width: 70, height: 70)
                                    .padding(.leading, 20)
                                    .foregroundColor(.black)
                                Text("Guest")
                                    .font(.system(size: 20, weight: .medium, design: .default))
                                    .foregroundStyle(.white)
                                    .padding(.leading, 5)
                            }
                        }
                        Spacer()
                        NavigationLink(destination: RankListView(viewModel: rankVM)) {  // Updated NavigationLink
                            Image(systemName: "trophy")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.yellow)
                                .frame(width: 40, height: 40)
                                .padding()
                        }
                    }
                    
                    .padding(.top, 15)
                    .padding()
                    .onAppear {
                            if let token = UserDefaults.standard.string(forKey: "authToken") {
                                let payload = loginVM.decode(jwtToken: token)
                                print("Decoded payload: \(String(describing: payload))") // Check payload content
                                if let userId = payload?["user_id"] as? Int {
                                    userVM.fetchUserDetail(userId: userId)
                                    print("Fetching details for user ID: \(userId)") // Confirm userId value
                                }
                            }
                    }
                    VStack {
                        Text("Nikmati pengalaman belajar yang menyenangkan!")
                            .foregroundColor(Color("boardingText"))
                            .font(.system(size: 30, weight: .heavy, design: .default))
                    }
                    .padding()
                    .padding(.leading, 10)
                    VStack {
                        TabView {
                            ForEach(1...4, id: \.self) { categoryId in
                                ZStack {
                                    Image("card-\(categoryId)")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 600, height: 500)
                                    VStack {
                                        Spacer()
                                        // Display total soal per category
                                        Text("\(soalVM.totalDataByCategory[categoryId] ?? 0) Quiz")
                                        
                                            .font(.system(size: 20, weight: .bold, design: .default))
                                            .foregroundColor(.white)
                                            .padding(.top, 20)
                                        Button(action: {
                                            if loginVM.isAuthenticated {
                                                selectedCategoryId = categoryId
                                                destination = .soalDetail
                                                isNavigating = true
                                            } else {
                                                destination = .login
                                                isNavigating = true
                                            }
                                        }) {
                                            Text("Play Quiz")
                                                .font(.system(size: 18, weight: .bold, design: .default))
                                                .foregroundColor(Color("boardingText"))
                                                .padding()
                                                .background(Color.white)
                                                .cornerRadius(50)
                                                .shadow(radius: 2)
                                        }
                                    }
                                    .frame(width: 303, height: 472, alignment: .center)

                                }
                                .onAppear {
                                    soalVM.fetchSoal(forCategory: categoryId)
                                }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .frame(height: 600)
                    }
                    .onAppear {
                        loginVM.checkAuthStatus()
                    }
                    
                    .navigationDestination(isPresented: $isNavigating) {
                        if let destination = destination {
                            switch destination {
                            case .categoryList:
                                CategoryListView()
                            case .login:
                                LoginView()
                            case .soalDetail:
                                SoalDetailView(viewModel: soalVM, selectedCategoryId: $selectedCategoryId, userId: $userId)
                            case .trophy:
                                RankListView(viewModel: rankVM)
                            }
                            
                        }
                    }
                    .navigationBarHidden(true)
                }
            }
        }
    }
}

struct Dasboard_Previews: PreviewProvider {
    static var previews: some View {
        Dasboard()
    }
}
