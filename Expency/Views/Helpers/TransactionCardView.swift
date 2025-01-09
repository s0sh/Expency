//
//  TransactionCardView.swift
//  Expency
//
//  Created by Roman Bigun on 08.01.2025.
//

import SwiftUI

struct TransactionCardView: View {
    
    let transaction: Transaction
    
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
            })
            .lineLimit(1)
            .hSpacing(.leading)
            
            Text(currencyString(transaction.amount, allowedDigits: 1))
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(.background, in: .rect(cornerRadius: 10))
    }
}
//
//#Preview {
//    TransactionCardView()
//}
