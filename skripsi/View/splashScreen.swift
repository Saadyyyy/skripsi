//
//  splashScreen.swift
//  skripsi
//
//  Created by Laode Saady on 15/08/24.
//

import Foundation
import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            Boarding() // Ganti dengan tampilan utama aplikasi setelah splash screen
        } else {
            ZStack {
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea(edges: .all)
                
                VStack {
                    Text("Bank Soal .")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 48, weight: .black, design: .default))
                        .padding()
                }
            }
            .onAppear {
                // Timer untuk mengubah ke tampilan utama setelah 2 detik
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//        SplashScreen()
//    }
//}

