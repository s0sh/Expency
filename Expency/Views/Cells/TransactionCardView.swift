//
//  TransactionCardView.swift
//  Expency
//
//  Created by Roman Bigun on 08.01.2025.
//

import SwiftUI

struct TransactionCardView: View {
    
    @Environment(\.modelContext) private var context
    
    @State private var hideCell: Bool = false
    
    let transaction: Transaction
    
    var showTrachButton: Bool = true
    
    var body: some View {
        HStack(spacing: 12) {
            Text("\(String(transaction.title.prefix(1)))")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 45, height: 45)
                .background(transaction.color.gradient, in: .circle)
            VStack(alignment: .leading, spacing: 4, content: {
                
                Text(transaction.title)
                    .foregroundStyle(Color.primary)
                
                Text(transaction.remarks)
                    .font(.caption)
                    .foregroundStyle(Color.primary.secondary)
                
                Text(format(date: transaction.dateAdded, format: "dd MM yyy"))
                    .font(.caption2)
                    .foregroundStyle(.gray)
                
                Text(transaction.category)
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .foregroundStyle(.white)
                    .background(transaction.category == "Income" ?
                                Color.green.gradient.opacity(0.6) : Color.red.gradient.opacity(0.6),
                                in: .capsule)
                
            })
            .lineLimit(1)
            .hSpacing(.leading)
            
            VStack(spacing: 8) {
                Text(currencyString(transaction.amount, allowedDigits: 1))
                    .fontWeight(.semibold)
                    .padding(.top, 25)
                    .overlay(alignment: .topTrailing, content: {
                        if showTrachButton {
                            Button(action: {
                                context.delete(transaction)
                                hideCell = true
                            }) {
                                Image(systemName: "trash")
                                    .resizable()
                                    .frame(width: 23, height: 25)
                                    .tint(Constants.Colors.appTint.opacity(0.6))
                                
                                
                            }.offset(y: -10)
                        }
                        
                    }).animation(.snappy, value: hideCell)
            }
            
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(transaction.color.opacity(0.15), in: .rect(cornerRadius: 10))
        .transition(.move(edge: .top))
    }
}

#Preview {
    TransactionCardView(transaction: Transaction(title: "Title",
                                                 remarks: "Test",
                                                 amount: 345.3,
                                                 dateAdded: .now,
                                                 category: .expence,
                                                 tintColor: .init(color: "red", value: .red)))
}
