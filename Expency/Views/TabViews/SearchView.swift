//
//  SearchView.swift
//  Expency
//
//  Created by Roman Bigun on 07.01.2025.
//

import SwiftUI
import Combine

struct SearchView: View {
    
    @State private var searchText: String = ""
    @State private var filterText: String = ""
    @State private var selectedCategory: Category? = nil
    
    var searchPublisher = PassthroughSubject<String, Never>()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 12) {
                    FilterTransactionView(category: selectedCategory,
                                          searchText: filterText) { transactions in
                        ForEach(transactions) { transaction in
                            NavigationLink {
                                TransactionView(editTransaction: transaction)
                            } label: {
                                TransactionCardView(transaction: transaction)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(15)
            }
            .overlay(content: {
                ContentUnavailableView("Search Transactions", systemImage: "magnifyingglass")
                    .opacity(filterText.isEmpty ? 1: 0)
            })
            .onChange(of: searchText, { oldValue, newValue in
                if newValue.isEmpty {
                    searchText = ""
                }
                searchPublisher.send(newValue)
            })
            .onReceive(searchPublisher.debounce(for: .seconds(0.3),
                                                scheduler: DispatchQueue.main),
                       perform: { text in
                filterText = text
                print(text)
            })
            .searchable(text: $searchText)
            .navigationTitle("Search")
            .background(.gray.opacity(0.15))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ToolbarContent()
                }
            }
        }
    }
    
    @ViewBuilder func ToolbarContent() -> some View {
        Menu {
            
            Button {
                selectedCategory = nil
            } label: {
                HStack {
                    Text("Both")
                    if selectedCategory == nil {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            ForEach(Category.allCases, id: \.rawValue) { category in
                Button {
                    selectedCategory = category
                } label: {
                    HStack {
                        Text(category.rawValue)
                        if selectedCategory == category {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label : {
            Image(systemName: "slider.vertical.3")
                
        }
        .tint(Constants.Colors.appTint)
    }
}

#Preview {
    SearchView()
}
