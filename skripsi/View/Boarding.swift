import SwiftUI

struct Boarding: View {
    @State private var showLogin = false
    @State private var selectedTab = 1
    @StateObject private var viewModel = LoginViewModel()
    var body: some View {
        NavigationView {
            ZStack {
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea(edges: .all)
                
                VStack {
                    VStack(alignment: .leading, spacing: 10) {
                        // Top text elements
                        Text("Get Ready For The")
                            .foregroundStyle(Color("boardingText"))
                            .font(.system(size: 36, weight: .heavy, design: .default))
                        
                        HStack {
                            Text("Challenge")
                                .foregroundStyle(Color("boardingText"))
                                .font(.system(size: 36, weight: .heavy, design: .default))
                            Image(systemName: "trophy")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.yellow)
                                .frame(width: 40, height: 40)
                        }
                        
                        Text("Quiz Awaits You!")
                            .foregroundStyle(Color("boardingText"))
                            .font(.system(size: 36, weight: .heavy, design: .default))
                        Text("Challenge your mind with fun quizzes!")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 16, weight: .bold, design: .default))
                    }
                    .padding(.leading, 40)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom,50)
                    
                    
                    ZStack {
                        TabView(selection: $selectedTab) {
                            //card 2
                            ZStack {
                                VStack {
                                    Image("Boarding-3")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 350, height: 400)
                                }
                            }
                            .padding()
                            .tag(0) // Indeks pertama
                            
                            // Card 1
                            ZStack {
                                VStack {
                                    Image("Boarding-1")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 350, height: 400)
                                }
                            }
                            .padding()
                            .tag(1)
                            
                            // Card 3
                            ZStack {
                                VStack {
                                    Image("Boarding-2")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 350, height: 400)
                                }
                            }
                            .padding()
                            .tag(2)
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .frame(width: 350, height: 410)
                        
                    }
                    .padding(.top, 10)
                    
                    NavigationLink(destination: Dasboard().navigationBarBackButtonHidden(true)) {
                        Text("Start Quiz")
                            .font(.system(size: 18, weight: .heavy, design: .default))
                            .foregroundColor(Color("boardingText"))
                            .padding()
                            .background(Color.white)
                            .cornerRadius(50)
                            .shadow(radius: 5)
                    }
                    .padding(.top, 50)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Boarding()
    }
}
