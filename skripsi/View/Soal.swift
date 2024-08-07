//
//  Soal.swift
//  skripsi
//
//  Created by Laode Saady on 03/09/24.
//

import SwiftUI

struct SoalDetailView: View {
    @StateObject private var viewModel = SoalViewModel()
    @StateObject private var categoryViewModel = CategoryViewModel()
    @StateObject private var rankViewModel = RankViewModel()
    @StateObject private var userVM = UserViewModel() // Tambahkan ini
    @Binding var selectedCategoryId: Int
    @Binding var userId: Int
    
    @State private var showNextAlert = false
    @State private var selectedAnswer: String?
    @State private var isAnswerCorrect = false // Menyimpan status jawaban
    @State private var answeredCount: Int = 0
    @State private var showAlert = false
    @State private var isFinishQuizActive = false // State for NavigationLink to Finish Page
    
    @State private var isSelectedA = false
    @State private var isSelectedB = false
    @State private var isSelectedC = false
    @State private var isSelectedD = false

    init(viewModel: SoalViewModel, selectedCategoryId: Binding<Int> , userId : Binding<Int>) {
          _viewModel = StateObject(wrappedValue: viewModel)
          _selectedCategoryId = selectedCategoryId
          _userId = userId
      }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // Judul dan jumlah soal
                HStack {
                    Spacer()
                    Text(categoryViewModel.category)
                        .font(.system(size: 23, weight: .medium, design: .default))
                        .fontWeight(.heavy)
                        .padding(.vertical)
                    Spacer()
                }
                .padding(.top, -70)
                .background(Color(.systemBackground))

                HStack {
                    Spacer()
                    Text("\(viewModel.totalDataByCategory[selectedCategoryId] ?? 0) Soal")
                    Spacer()
                }
                .padding(.top, -25)
                .background(Color(.systemBackground))

                Spacer()

                // Tombol untuk pindah ke soal sebelumnya
                if viewModel.currentIndex > 0 {
                    Button(action: {
                        viewModel.previousSoal()
                        selectedAnswer = nil
                        answeredCount -= 1
                    }) {
                        Image(systemName: "arrowshape.left.fill")
                    }
                    .padding(.top, 20)
                    .foregroundColor(.black)
                }

                // Progress Bar
                ProgressView(value: Double(answeredCount), total: Double(viewModel.totalDataByCategory[selectedCategoryId] ?? 0))
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding(.vertical)

                Text("Soal \(viewModel.currentIndex + 1)")
                    .font(.system(size: 24, weight: .heavy, design: .default))
                    .padding(15)

                if let soal = viewModel.currentSoal {
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(alignment: .leading, spacing: 1) {
                            Text(soal.soal)
                                .padding(12)
                                .font(.system(size: 20, weight: .semibold, design: .default))
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)

                            // Opsi jawaban
                            AnswerButton(answer: soal.jawabanA, selectedAnswer: $selectedAnswer, correctAnswer: soal.jawabanBenar, isSelected: $isSelectedA)
                            AnswerButton(answer: soal.jawabanB, selectedAnswer: $selectedAnswer, correctAnswer: soal.jawabanBenar, isSelected: $isSelectedB)
                            AnswerButton(answer: soal.jawabanC, selectedAnswer: $selectedAnswer, correctAnswer: soal.jawabanBenar, isSelected: $isSelectedC)
                            AnswerButton(answer: soal.jawabanD, selectedAnswer: $selectedAnswer, correctAnswer: soal.jawabanBenar, isSelected: $isSelectedD)

                            HStack {
                                // Tombol untuk cek jawaban
                                Button(action: {
                                    checkAnswer()
                                    showAlert = true
                                }) {
                                    Text("Check              ")
                                        .font(.system(size: 20, weight: .heavy, design: .default))
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                                .padding(.top, 20)
                                .padding(18)
                                .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text(isAnswerCorrect ? "Correct!" : "Incorrect!"),
                                        message: Text(isAnswerCorrect ? "Jawaban Anda benar." : "Jawaban Anda salah."),
                                        dismissButton: .default(Text("OK"))
                                    )
                                }
                                Spacer()

                                // Tombol "Next" atau "Finish"
                                if viewModel.currentIndex + 1 < viewModel.totalDataByCategory[selectedCategoryId] ?? 0 {
                                    Button(action: {
                                        let soalId = viewModel.currentSoal?.id ?? 0 // Dapatkan ID soal saat ini

                                        rankViewModel.createRank(userId: userId, categoryId: selectedCategoryId, soalId: soalId, next: false)
                                        
                                        // Check if the answer is correct
                                        if isAnswerCorrect {
                                            // If the answer is correct, update the rank with next = true
                                            rankViewModel.updateRank(userId: userId, soalId: soalId) // Call updateRank here
                                            
                                            // Proceed to the next question
                                            viewModel.nextSoal()
                                            answeredCount += 1
                                            
                                            // Update rank after the next question is chosen
                                            DispatchQueue.main.async {
                                                if let newSoalId = viewModel.currentSoal?.id {
                                                    rankViewModel.fetchCheckRank(userId: userId, soalId: newSoalId, categoryId: selectedCategoryId)
                                                }
                                            }
                                        } else {
                                            // If the answer is incorrect, just move to the next question
                                            viewModel.nextSoal()
                                            answeredCount += 1
                                            
                                            // Update rank after the next question is chosen
                                            DispatchQueue.main.async {
                                                if let newSoalId = viewModel.currentSoal?.id {
                                                    rankViewModel.fetchCheckRank(userId: userId, soalId: newSoalId, categoryId: selectedCategoryId)
                                                }
                                            }
                                        }
                                    }) {
                                        Text("Next")
                                            .font(.system(size: 20, weight: .heavy, design: .default))
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(rankViewModel.checkData?.Next == true || isAnswerCorrect ? Color.green : Color.gray)
                                            .cornerRadius(10)
                                    }
                                    .padding(.top, 20)
                                    .padding(18)
                                    .disabled(!isAnswerCorrect && rankViewModel.checkData?.Next != true)

                                } else {
                                    NavigationLink(
                                        destination: FinishQuiz(selectedCategoryId: selectedCategoryId),
                                        isActive: $isFinishQuizActive
                                    ) {
                                        Button(action: {
                                            isFinishQuizActive = true
                                        }) {
                                            Text("Finish")
                                                .font(.system(size: 20, weight: .heavy, design: .default))
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(Color.red)
                                                .cornerRadius(10)
                                                .frame(width: 150, height: 40)
                                        }
                                        .padding(.top, 20)
                                        .padding(18)
                                        .navigationBarHidden(true)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .onAppear {
                viewModel.fetchSoal(forCategory: selectedCategoryId)
                categoryViewModel.getCategoriesDetail(categoryId: selectedCategoryId)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Delay to ensure soals are fetched
                    if let soalId = viewModel.currentSoal?.id {
                        print("Fetched soal ID: \(soalId)")
                        rankViewModel.fetchCheckRank(userId: userId, soalId: soalId, categoryId: selectedCategoryId)
                    } else {
                        print("Failed to fetch soal ID")
                    }
                }
            }

        }
    }

    private func checkAnswer() {
        guard let soal = viewModel.currentSoal else { return }
        isAnswerCorrect = selectedAnswer == soal.jawabanBenar
    }
}

struct AnswerButton: View {
    var answer: String
    @Binding var selectedAnswer: String?
    var correctAnswer: String? // Jawaban yang benar
    @Binding var isSelected: Bool

    var body: some View {
        Button(action: {
            selectedAnswer = answer
            isSelected = true // Set selected state when button is clicked
        }) {
            HStack {
                Text(answer)
                    .font(.system(size: 20, weight: .semibold, design: .default))
                    .foregroundColor(selectedAnswer == answer ? .black : .black)
                    .padding([.leading, .trailing], 20)
                    .padding([.top, .bottom], 10)
                Spacer()
                Circle()
                    .frame(width: 40, height: 30)
                    .padding(.leading, 20)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(selectedAnswer == answer ? Color.blue : Color.white)
        .cornerRadius(9)
        .overlay(
            RoundedRectangle(cornerRadius: 9)
                .stroke(Color.black, lineWidth: 1)
        )
        .padding(10)
    }
}

struct SoalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SoalDetailView(viewModel: SoalViewModel(), selectedCategoryId: .constant(2), userId: .constant(1))
    }
}
