//
//  HomeView.swift
//  SSC
//
//  Created by Doran on 2/19/25.
//

import SwiftUI

struct HomeView: View {
    @State private var isHidden: [Bool] = Array(repeating: false, count: quizData.count)
    @State private var selectedIndex: Int? = nil
    @State private var isAnimating: Bool = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                VStack(spacing: 0){
                    header(screenSize: geo.size)
                    
                    HStack(alignment: .center, spacing: 0) {
                        ForEach(0..<quizData.count, id: \.self) { index in
                            if selectedIndex == nil || selectedIndex == index {
                                HStack(spacing: 0){
                                    Image(quizData[index].imageURL)
                                        .resizable()
                                        .cornerRadius(25)
                                        .frame(width: selectedIndex == index ? geo.size.width / 2.5 : geo.size.width / 3,
                                               height: selectedIndex == index ? geo.size.width / 2.5 : geo.size.width / 3)
                                        .shadow(color: .gray, radius: 5, x: 0, y: 3)
                                        .onTapGesture {
                                            handleTap(index: index)
                                        }
                                        .disabled(isAnimating)
                                }
                            }
                        }
                        .position(x: selectedIndex != nil ? geo.size.width / 4.5: geo.size.width / 4, y: selectedIndex != nil ? geo.size.height / 2.9 : geo.size.height / 2.7)
                        .animation(.spring(), value: selectedIndex)
                        if let selectedIndex = selectedIndex, isHidden[selectedIndex] {
                            QuizInfoView(category: quizData[selectedIndex].category)
                                .frame(width: geo.size.width / 2)
                                .padding(.leading, geo.size.width * 0.01)
                                .transition(.move(edge: .trailing))
                        }
                    }
                }
            }
            .background(
                Color(hex: "#E6F0FF")
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
}

private extension HomeView {
    func header(screenSize: CGSize) -> some View {
        HStack{
            Text("Signy Play!")
                .font(.system(size: screenSize.height * 0.08, weight: .bold))
                .foregroundColor(selectedIndex != nil ? Color(hex: "#E6F0FF") : Color(hex: "#bc81f7"))
            Spacer()
        }
        .padding(EdgeInsets(top: screenSize.height*0.09, leading: screenSize.width * 0.05, bottom: 0, trailing: 0))
    }
}

private extension HomeView {
    func handleTap(index: Int) {
        guard !isAnimating else { return }
        isAnimating = true
        withAnimation {
            selectedIndex = (selectedIndex == index) ? nil : index
            isHidden[index].toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isAnimating = false
        }
    }
    
}

