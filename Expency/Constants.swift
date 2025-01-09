//
//  Constants.swift
//  Expency
//
//  Created by Roman Bigun on 07.01.2025.
//

import SwiftUI

enum Constants {
    
    enum Colors {
        
        static let appTint: Color = .red
        
        static let transactionTints: [TransactionTintColor] = [
            .init(color: "Red", value: .red),
            .init(color: "Blue", value: .blue),
            .init(color: "Pink", value: .pink),
            .init(color: "Purple", value: .purple),
            .init(color: "Brown", value: .brown),
            .init(color: "Orange", value: .orange),
            .init(color: "Cyan", value: .cyan),
            .init(color: "Mint", value: .mint),
            .init(color: "Teal", value: .teal)
        ]
    }
}

