//
//  CartsView.swift
//  Expency
//
//  Created by Roman Bigun on 07.01.2025.
//

import SwiftUI
import Charts
import SwiftData

struct ChartsView: View {
    
    @Query(animation: .snappy) private var transactions: [Transaction]
    
    @State private var chartGroups: [ChartGroup] = []
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 10) {
                    ChartView()
                        .frame(height: 200)
                        .padding(10)
                        .padding(.top, 10)
                        .background(.background, in: .rect(cornerRadius: 10))
                    
                    ForEach(chartGroups) { group in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(format(date: group.date, format: "MMM yy"))
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .hSpacing(.leading)
                            NavigationLink {
                                ListOfExpense(month: group.date)
                            } label: {
                                CardView(income: group.totalIncome, expence: group.totalExpense)
                            }
                            
                        }
                    }
                }
                .padding(15)
            }
            .navigationTitle("Graphs")
            .background(.gray.opacity(0.15))
            .onAppear {
                createChartGroup()
            }
        }
    }
    
    @ViewBuilder
    func ChartView() -> some View {
        Chart {
            ForEach(chartGroups) { group in
                ForEach(group.categories) { chart in
                    BarMark(
                        x: .value("Month", format(date: group.date, format: "MMM yy")),
                        y: .value(chart.category.rawValue, chart.totalValue),
                        width: 20
                    )
                    .position(by: .value("Category", chart.category.rawValue), axis: .horizontal)
                    .foregroundStyle(by: .value("Category", chart.category.rawValue))
                }
            }
        }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 4)
        .chartLegend(position: .bottom, alignment: .trailing)
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                let doubleValue = value.as(Double.self) ?? 0

                AxisGridLine()
                AxisTick()
                
                AxisValueLabel {
                    Text(axisLabel(doubleValue))
                }
                
            }
        }
        .chartForegroundStyleScale(range: [Color.green.gradient, Color.red.gradient])
    }
    
    func createChartGroup() {
        Task.detached(priority: .high) {
            let calendar = Calendar.current
            let groupByDate = await Dictionary(grouping: transactions) { transaction in
                let components = calendar.dateComponents([.month, .year], from: transaction.dateAdded)
                return components
            }
            let sortedGroup = groupByDate.sorted {
                let date1 = calendar.date(from: $0.key) ?? .init()
                let date2 = calendar.date(from: $1.key) ?? .init()
                
                return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
            }
            
            let chartGroups = sortedGroup.compactMap { dict -> ChartGroup? in
                let date = calendar.date(from: dict.key) ?? .init()
                let income = dict.value.filter({ $0.category == Category.income.rawValue })
                let expense = dict.value.filter({ $0.category == Category.expence.rawValue })
                
                let incomeTotal = total(income, category: .income)
                let expenseTotal = total(expense, category: .expence)
                
                return .init(date: date,
                             categories: [.init(totalValue: incomeTotal, category: .income),
                                          .init(totalValue: expenseTotal, category: .expence)],
                             totalIncome: incomeTotal,
                             totalExpense: expenseTotal)
            }
            
            await MainActor.run {
                self.chartGroups = chartGroups
            }
        }
        
        
    }
    
    func axisLabel(_ value: Double) -> String {
        let intValue = Int(value)
        let kValue = Int(value) / 1000
        return intValue < 100 ? "\(intValue)" : "\(kValue)k"
    }
}
//
//#Preview {
//    ChartsView()
//}

struct ListOfExpense: View {
    let month: Date
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                Section {
                    FilterTransactionView(startDate: month.startOfMonth,
                                          endDate: month.endOfMonth, category: .income) { transacitons in
                        ForEach(transacitons) { transaction in
                            NavigationLink(value: transaction) {
                                TransactionCardView(transaction: transaction)
                            }
                        }
                    }
                } header: {
                    Text("Income")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                }
                
                Section {
                    FilterTransactionView(startDate: month.startOfMonth,
                                          endDate: month.endOfMonth, category: .expence) { transacitons in
                        ForEach(transacitons) { transaction in
                            NavigationLink(value: transaction) {
                                TransactionCardView(transaction: transaction)
                            }
                            
                        }
                    }
                } header: {
                    Text("Expense")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                }
            }
            .padding(15)
            
            
        }
        .background(.gray.opacity(0.15))
        .navigationTitle(format(date: month, format: "MMM yy"))
        .navigationDestination(for: Transaction.self) { transaction in
            TransactionView(editTransaction: transaction)
        }
    }
}
