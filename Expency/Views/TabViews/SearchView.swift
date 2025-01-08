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
    
    var searchPublisher = PassthroughSubject<String, Never>()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 12) {
                    
                }
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
        }
    }
}

#Preview {
    SearchView()
}
