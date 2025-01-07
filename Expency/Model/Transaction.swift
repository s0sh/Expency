//
//  Transaction.swift
//  Expency
//
//  Created by Roman Bigun on 07.01.2025.
//

import SwiftUI

struct Transaction: Identifiable {
    let id: UUID = .init()
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
    
    static var mockTransactions: [Transaction] = [
        .init(title: "Magic Keyboard", remarks: "Apple Product", amount: 129, dateAdded: .now, category: .expence, tintColor: Constants.Colors.transactionTints.randomElement()!),
        .init(title: "Apple Music", remarks: "Subscription", amount: 10.99, dateAdded: .now, category: .expence, tintColor: Constants.Colors.transactionTints.randomElement()!),
        .init(title: "iCloud", remarks: "Subscription", amount: 0.99, dateAdded: .now, category: .expence, tintColor: Constants.Colors.transactionTints.randomElement()!),
        .init(title: "Payment", remarks: "Payment Recieved!", amount: 2499, dateAdded: .now, category: .income, tintColor: Constants.Colors.transactionTints.randomElement()!),
    ]
    
}

struct TransactionTintColor: Identifiable {
    let id: UUID = .init()
    var color: String
    var value: Color
}
