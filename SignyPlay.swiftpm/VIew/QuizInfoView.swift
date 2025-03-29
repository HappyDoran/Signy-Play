//
//  QuizInfoView.swift
//  SSC
//
//  Created by Doran on 2/17/25.
//
import SwiftUI

struct QuizInfoView: View {
    private let category: String
    @State var questionCnt: Int = 5
    @State private var navigateToQuiz: Bool = false
    
    init(category: String){
        self.category = category
    }
    
    var body: some View {
        GeometryReader{ geo in
            VStack(spacing: 0){
                VStack(alignment: .leading, spacing : 0){
                    Text("\(category)!")
                        .font(.system(size: geo.size.width * 0.1, weight: .bold))
                        .foregroundColor(.black)
                        .frame(height: geo.size.height*0.1)
                        .padding(.bottom, geo.size.height*0.05)
                    
                    Text("How many questions?")
                        .font(.system(size: geo.size.width * 0.05, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.bottom, geo.size.height*0.02)
                    
                    HStack {
                        ForEach(0..<3) { index in
                            ZStack {
                                Button(action: {
                                    questionCnt = (index + 1) * 5
                                }) {
                                    Text("\((index + 1) * 5) Questions")
                                        .font(.system(size: geo.size.width * 0.03, weight: .bold))
                                        .foregroundColor(questionCnt == (index + 1) * 5 ? Color(hex: "#000000"): Color(hex: "#FFFFFF"))
                                        .padding()
                                        .background(questionCnt == (index + 1) * 5 ? Color(hex: "#FFFFFF") : Color(hex: "#000000"))
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding(.bottom, geo.size.height*0.1)
                    
                    Button(action: {navigateToQuiz = true}){
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(hex: "1ec996"))
                                .frame(width : geo.size.width, height: geo.size.height * 0.1)
                            Text("Start!")
                                .font(.system(size: geo.size.width * 0.04, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .position(x : geo.size.width / 2.5, y : geo.size.height / 2.1)
        }
        .navigationDestination(isPresented: $navigateToQuiz){
            QuizView(questionCount: questionCnt, category: category)
        }
    }
}

#Preview {
    QuizInfoView(category: "Alphabet")
}
