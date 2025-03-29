//
//  SingleLanguageItem.swift
//  SSC
//
//  Created by Doran on 2/15/25.
//

import SwiftUI

struct SignLanguageItem: Identifiable {
    let id = UUID()
    let category: String
    let title: String
    let imageURL: String
}
