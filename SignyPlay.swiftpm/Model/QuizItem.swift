//
//  QuizModel.swift
//  SSC
//
//  Created by Doran on 2/17/25.
//

import SwiftUI

struct QuizItem: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let imageURL: String
}

let quizData: [QuizItem] = [
    QuizItem(title: "Alphabet", category: "Alphabet", imageURL: "AlphabetButton"),
    QuizItem(title: "Words", category: "Words", imageURL: "WordsButton"),
]
