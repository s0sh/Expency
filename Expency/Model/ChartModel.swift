//
//  ChartModel.swift
//  Expency
//
//  Created by Roman Bigun on 09.01.2025.
//

import SwiftUI

struct ChartGroup: Identifiable {
    let id: UUID = .init()
    let date: Date
    let categories: [ChartCategory]
    let totalIncome: Double
    let totalExpense: Double
}

struct ChartCategory: Identifiable {
    let id: UUID = .init()
    let totalValue: Double
    let category: Category
}
