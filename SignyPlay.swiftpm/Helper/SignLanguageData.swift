//
//  SignLanguageData.swift
//  SSC
//
//  Created by Doran on 2/16/25.
//

import SwiftUI

class SignLanguageData: ObservableObject {
    @Published var alphabets: [SignLanguageItem] = [
        SignLanguageItem(category: "Alphabet", title: "A", imageURL: "A"),
        SignLanguageItem(category: "Alphabet", title: "B", imageURL: "B"),
        SignLanguageItem(category: "Alphabet", title: "C", imageURL: "C"),
        SignLanguageItem(category: "Alphabet", title: "D", imageURL: "D"),
        SignLanguageItem(category: "Alphabet", title: "E", imageURL: "E"),
        SignLanguageItem(category: "Alphabet", title: "F", imageURL: "F"),
        SignLanguageItem(category: "Alphabet", title: "G", imageURL: "G"),
        SignLanguageItem(category: "Alphabet", title: "H", imageURL: "H"),
        SignLanguageItem(category: "Alphabet", title: "I", imageURL: "I"),
        SignLanguageItem(category: "Alphabet", title: "J", imageURL: "J"),
        SignLanguageItem(category: "Alphabet", title: "K", imageURL: "K"),
        SignLanguageItem(category: "Alphabet", title: "L", imageURL: "L"),
        SignLanguageItem(category: "Alphabet", title: "M", imageURL: "M"),
        SignLanguageItem(category: "Alphabet", title: "N", imageURL: "N"),
        SignLanguageItem(category: "Alphabet", title: "O", imageURL: "O"),
        SignLanguageItem(category: "Alphabet", title: "P", imageURL: "P"),
        SignLanguageItem(category: "Alphabet", title: "Q", imageURL: "Q"),
        SignLanguageItem(category: "Alphabet", title: "R", imageURL: "R"),
        SignLanguageItem(category: "Alphabet", title: "S", imageURL: "S"),
        SignLanguageItem(category: "Alphabet", title: "T", imageURL: "T"),
        SignLanguageItem(category: "Alphabet", title: "U", imageURL: "U"),
        SignLanguageItem(category: "Alphabet", title: "V", imageURL: "V"),
        SignLanguageItem(category: "Alphabet", title: "W", imageURL: "W"),
        SignLanguageItem(category: "Alphabet", title: "X", imageURL: "X"),
        SignLanguageItem(category: "Alphabet", title: "Y", imageURL: "Y"),
        SignLanguageItem(category: "Alphabet" ,title: "Z", imageURL: "Z")
    ]
    
    @Published var words: [SignLanguageItem] = [
        SignLanguageItem(category: "Words", title: "Apple", imageURL: "Apple"),
        SignLanguageItem(category: "Words", title: "Banana", imageURL: "Banana"),
        SignLanguageItem(category: "Words", title: "Cat", imageURL: "Cat"),
        SignLanguageItem(category: "Words", title: "Dog", imageURL: "Dog"),
        SignLanguageItem(category: "Words", title: "Elephant", imageURL: "Elephant"),
        SignLanguageItem(category: "Words", title: "Fish", imageURL: "Fish"),
        SignLanguageItem(category: "Words", title: "Horse", imageURL: "Horse"),
        SignLanguageItem(category: "Words", title: "House", imageURL: "House"),
        SignLanguageItem(category: "Words", title: "Icecream", imageURL: "IceCream"),
        SignLanguageItem(category: "Words", title: "Juice", imageURL: "Juice"),
        SignLanguageItem(category: "Words", title: "Lion", imageURL: "Lion"),
        SignLanguageItem(category: "Words", title: "Monkey", imageURL: "Monkey"),
        SignLanguageItem(category: "Words", title: "Orange", imageURL: "Orange"),
        SignLanguageItem(category: "Words", title: "Pants", imageURL: "Pants"),
        SignLanguageItem(category: "Words", title: "Rainbow", imageURL: "Rainbow"),
        SignLanguageItem(category: "Words", title: "Sun", imageURL: "Sun"),
        SignLanguageItem(category: "Words", title: "Tomato", imageURL: "Tomato"),
        SignLanguageItem(category: "Words", title: "Umbrella", imageURL: "Umbrella"),
        SignLanguageItem(category: "Words", title: "Violin", imageURL: "Violin"),
    ]
}

extension SignLanguageData {
    func getRandomQuestions(from category: String, count: Int) -> [SignLanguageItem] {
        let items = category == "Alphabet" ? alphabets : words
        
        if count >= items.count {
            return items.shuffled()
        }
        
        return Array(items.shuffled().prefix(count))
    }
}
