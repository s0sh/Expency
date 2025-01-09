//
//  Transaction.swift
//  Expency
//
//  Created by Roman Bigun on 07.01.2025.
//

import SwiftUI
import SwiftData

@Model
class Transaction {
    var title: String
    var remarks: String
    var amount: Double
    var dateAdded: Date
    var category: String
    var tintColor: String
    
    init(title: String, remarks: String, amount: Double, dateAdded: Date, category: Category, tintColor: TransactionTintColor) {
        self.title = title
        self.remarks = remarks
        self.amount = amount
        self.dateAdded = dateAdded
        self.category = category.rawValue
        self.tintColor = tintColor.color
    }
    
    var color: Color {
        return Constants.Colors.transactionTints.first(where: { $0.color == tintColor } )?.value ?? Constants.Colors.appTint
    }
   
    var tint: TransactionTintColor? {
        return Constants.Colors.transactionTints.first(where: { $0.color == tintColor })
    }
    
    var rawCategory: Category? {
        return Category.allCases.first(where: {category == $0.rawValue })
    }
}

struct TransactionTintColor: Identifiable {
    let id: UUID = .init()
    var color: String
    var value: Color
}
