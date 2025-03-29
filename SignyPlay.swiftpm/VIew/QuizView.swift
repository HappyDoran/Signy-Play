//
//  QuizView.swift
//  SSC
//
//  Created by Doran on 2/16/25.
//

import SwiftUI

struct QuizView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ContentViewModel()
    @StateObject private var signData = SignLanguageData()
    @State private var questions: [SignLanguageItem] = []
    @State private var currentQuestionIndex: Int = 0 
    @State private var borderColor: Color = Color(hex: "f2496d")
    @State private var userAnswer: String = ""
    @State private var popToHomeView: Bool = false
    @State private var isObserve: Bool = true
    
    private let questionCount: Int
    private let category: String
    
    init(questionCount: Int, category: String){
        self.questionCount = questionCount
        self.category = category
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                HStack(spacing: 0){
                    //카메라 들어갈 자리
                    cameraArea(screenSize: geo.size)
                    
                    VStack(spacing: 0){
                        // 그림 들어갈 자리
                        paintArea(screenSize: geo.size)
                        
                        // 측정 결과 들어갈 자리
                        resultArea(screenSize: geo.size)
                        
                        
                        textButton
                            .padding(.bottom, geo.size.height*0.05)
                        
                    }
                    .background(Color.clear)
                }
            }
            
            VStack(spacing: 0){
                progressBar(screenSize: geo.size)
                Spacer()
                questionButton
                    .padding(.bottom, geo.size.height*0.05)
            }
            .padding(.horizontal, geo.size.width*0.1)
        }
        .background(
            Color(hex: "#E6F0FF")
        )
        .edgesIgnoringSafeArea(.all)
        .onChange(of: viewModel.recognizedText) { newValue in
            if isObserve {
                userAnswer = newValue
                if newValue.lowercased() == questions[currentQuestionIndex].title.lowercased() {
                    borderColor = Color(hex: "1ec996")
                    isObserve = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        nextQuestion()
                        resetText()
                        isObserve = true
                    }
                } else {
                    borderColor = Color(hex: "f2496d")
                }
            }
        }
        .onChange(of: popToHomeView) { newValue in
            if newValue {
                dismiss()
            }
        }
        .onAppear {
            viewModel.startSession()
            generateQuestions()
        }
        .onDisappear {
            viewModel.stopSession()
        }
    }
}

private extension QuizView {
    func cameraArea(screenSize: CGSize) -> some View {
        ZStack{
            CameraPreviewView(cameraManager: viewModel.cameraManager)
            HandPoseOverlayView(boundingBox: viewModel.boundingBox, screenSize: screenSize, borderColor: borderColor)
        }
    }
    
    @ViewBuilder
    func paintArea(screenSize: CGSize) -> some View {
        if(!questions.isEmpty){
            Image(questions[currentQuestionIndex].imageURL)
                .resizable()
                .scaledToFit()
                .frame(width: screenSize.width / 3)
                .cornerRadius(40)
                .shadow(color: .gray, radius: 5, x: 0, y: 3)
                .padding(
                    EdgeInsets(
                        top: screenSize.height * 0.05,
                        leading: screenSize.width * 0.01,
                        bottom: 0,
                        trailing: screenSize.width * 0.01)
                )
        }
        else {
            Rectangle()
                .fill(Color.gray)
                .frame(width: screenSize.width / 3)
                .cornerRadius(40)
                .shadow(color: .black, radius: 5, x: 0, y: 3)
                .padding(
                    EdgeInsets(
                        top: screenSize.height * 0.05,
                        leading: screenSize.width * 0.01,
                        bottom: 0,
                        trailing: screenSize.width * 0.01)
                )
        }
    }
    
    func resultArea(screenSize: CGSize) -> some View {
        VStack(spacing: 0){
            HStack {
                Text("Current: \(viewModel.currentName)")
                    .font(.headline)
                Text("(\(String(format: "%.1f", viewModel.confidence * 100))%)")
                    .font(.subheadline)
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(10)
            .padding(.top)
            
            Spacer()
            Text(userAnswer)
                .font(.system(size: screenSize.width * 0.05, weight: .bold))
                .foregroundColor(.black)
                .frame(width: screenSize.width * 1/3, height: screenSize.height*0.1)
                .padding(.bottom, screenSize.height*0.05)
        }
    }
    
    func progressBar(screenSize: CGSize) -> some View {
        VStack(spacing: 0) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.2))
                    .frame(width: screenSize.width*0.8, height: 10)
                    .cornerRadius(25)
                
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: (CGFloat(currentQuestionIndex + 1) / CGFloat(questionCount)) * (screenSize.width * 0.8), height: 10)
                    .cornerRadius(25)
                    .animation(.easeInOut, value: currentQuestionIndex)
            }
            
            Text("\(currentQuestionIndex + 1) / \(questionCount)")
                .font(.title.bold())
                .foregroundColor(.black)
                .padding(.top, screenSize.height*0.01)
                
        }
    }
    
    var questionButton: some View {
        HStack {
            Button(action: previousQuestion) {
                Text("Previous")
                    .foregroundColor(.white)
                    .padding()
                    .background(currentQuestionIndex > 0 ? Color.blue : Color.gray)
                    .cornerRadius(10)
            }
            .disabled(currentQuestionIndex == 0)
            
            Button(action: nextQuestion) {
                Text("Next")
                    .foregroundColor(.white)
                    .padding()
                    .background(currentQuestionIndex < questions.count - 1 ? Color(hex: "1ec996") : Color.gray)
                    .cornerRadius(10)
            }
            .disabled(currentQuestionIndex == questions.count - 1)
        }
    }
    
    var textButton: some View {
        HStack {
            Button(action: removeLastText) {
                Text("Delete")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Button(action: resetText) {
                Text("Reset")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(hex: "f2496d"))
                    .cornerRadius(10)
            }
        }
    }
}

private extension QuizView{
    func generateQuestions() {
        questions = signData.getRandomQuestions(from: category, count: questionCount)
    }
    
    func previousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
            borderColor = Color(hex: "f2496d")
            resetText()
        }
    }
    
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            borderColor = Color(hex: "f2496d")
            resetText()
        }
        else {
            popToHomeView = true;
        }
    }
    
    func removeLastText(){
        if !userAnswer.isEmpty && !viewModel.recognizedText.isEmpty  {
            userAnswer.removeLast();
            viewModel.removeLastCharacter()
        }
    }
    
    func resetText(){
        userAnswer = ""
        viewModel.resetText()
    }
}

#Preview {
    QuizView(questionCount: 5, category: "Alphabet")
}
