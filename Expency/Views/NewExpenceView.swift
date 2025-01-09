//
//  NewExpenceView.swift
//  Expency
//
//  Created by Roman Bigun on 09.01.2025.
//

import SwiftUI

struct NewExpenceView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var editTransaction: Transaction?
    /// View Properties
    @State private var title: String = ""
    @State private var remark: String = ""
    @State private var amount: Double = .zero
    @State private var dateAdded: Date = .now
    @State private var category: Category = .expence
    /// Random Tint
    @State var tint = Constants.Colors.transactionTints.randomElement()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 15) {
                Text("Preview")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .hSpacing(.leading)
                
                /// Preview transaction Card View
                TransactionCardView(transaction: .init(title: title.isEmpty ? "Title" : title,
                                                       remarks: remark.isEmpty ? "Remark" : remark,
                                                             amount: amount,
                                                             dateAdded: dateAdded,
                                                             category: category,
                                                             tintColor: tint!))
                
                CustomSection("Title", "Magic Keyboard", value: $title)
                CustomSection("Remark", "Apple Prodct!", value: $remark)
                
                /// Amount and Category Check Boxs
                VStack(alignment: .leading, spacing: 10, content: {
                    Text("Amount & Category")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    HStack(spacing: 15) {
                        TextField("0.0", value: $amount, formatter: numberFormatter)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .background(.background, in: .rect(cornerRadius: 10))
                            .frame(maxWidth: 130)
                            .keyboardType(.decimalPad)
                        
                        /// Custom Check Box
                        CategoryCheckBox()
                    }
                })
                
                /// Date
                VStack(alignment: .leading, spacing: 10, content: {
                    Text("Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    
                    DatePicker("", selection: $dateAdded, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(.background, in: .rect(cornerRadius: 10))
                        .tint(Constants.Colors.appTint)
                })
            }
            .padding(15)
        }
        .navigationTitle("Add Transaction")
        .background(.gray.opacity(0.15))
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save", action: save)
                    .tint(Constants.Colors.appTint)
            }
        })
        .onAppear(perform: {
            if let editTransaction  {
                title = editTransaction.title
                remark = editTransaction.remarks
                amount = editTransaction.amount
                dateAdded = editTransaction.dateAdded
                if let category = editTransaction.rawCategory {
                    self.category = category
                }
                if let tint = editTransaction.tint {
                    self.tint = tint
                }
            }
        })
    }
    
    func save() {
        if editTransaction != nil {
            editTransaction?.title = title
            editTransaction?.remarks = remark
            editTransaction?.amount = amount
            editTransaction?.dateAdded = dateAdded
            editTransaction?.category = category.rawValue
        } else {
            let transaction = Transaction(title: title,
                                          remarks: remark,
                                          amount: amount,
                                          dateAdded: dateAdded,
                                          category: category,
                                          tintColor: tint!)
            context.insert(transaction)
        }
        
        dismiss()
    }
    /// Custom Section
    @ViewBuilder
    func CustomSection(_ title: String, _ hint: String, value: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
                .hSpacing(.leading)
            TextField(hint, text: value)
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .background(.background, in: .rect(cornerRadius: 10))
        })
    }
    /// Numbeer Formatter. 2 digits are alllowed
    var numberFormatter: NumberFormatter {
        var formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
    /// Custom Check Box
    @ViewBuilder
    func CategoryCheckBox() -> some View {
        HStack(spacing: 10) {
            ForEach(Category.allCases, id: \.rawValue) { category in
                HStack(spacing: 5) {
                    ZStack {
                        Image(systemName: "circle")
                            .font(.title3)
                            .foregroundStyle(Constants.Colors.appTint)
                        if self.category == category {
                            Image(systemName: "circle.fill")
                                .font(.caption)
                                .foregroundStyle(Constants.Colors.appTint)
                        }
                    }
                    Text(category.rawValue)
                        .font(.caption)
                }
                .contentShape(.rect)
                    .onTapGesture {
                        self.category = category
                    }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 15)
        .hSpacing(.leading)
        .background(.background, in: .rect(cornerRadius: 10))
    }
}

#Preview {
    NavigationStack {
        NewExpenceView()
    }
}
