//
//  RecentsView.swift
//  Expency
//
//  Created by Roman Bigun on 07.01.2025.
//

import SwiftUI
import SwiftData

struct RecentsView: View {
  
    /// User Properties
    @AppStorage("userName") private var userName: String = ""
    /// View Properties
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    @State private var selectedCategory: Category = .expence
    @State private var showFilterView: Bool = false
    /// For animation
    @Namespace private var animation
    
    var body: some View {
        GeometryReader {
            /// For animation purpose
            let size = $0.size
            NavigationStack {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                        Section {
                            /// Date fillter button
                            Button(action: {
                                showFilterView = true
                            }, label: {
                                Text("\(format(date: startDate, format: "dd - MM yy")) to \(format(date: endDate, format: "dd - MM yy"))")
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                            })
                            .hSpacing(.leading)
                           
                            FilterTransactionView(startDate: startDate, endDate: endDate) { transactions in
                                CardView(
                                    income: total(transactions, category: .income),
                                    expence: total(transactions, category: .expence)
                                )
                                /// Custom Segmented Control
                                CustomSegmentedControl()
                                    .padding(.bottom, 10)
                                /// Transactions List
                                TransactionsList(transactions: transactions, category: selectedCategory)
                            }

                        } header: {
                            HeaderView(size)
                        }

                    }
                    .padding(15)
                }
                .background(.gray.opacity(0.15))
                .blur(radius: showFilterView ? 8 : 0)
                .disabled(showFilterView)
            }
            .overlay {
                if showFilterView {
                    DateFilterView(start: startDate, end: endDate, onSubmit: { start, end in
                        startDate = start
                        endDate = end
                        showFilterView = false
                    }, onClose: {
                        showFilterView = false
                    })
                    .transition(.move(edge: .leading))
                }
            }.animation(.snappy, value: showFilterView)
        }
    }
    
    /// Header view
    @ViewBuilder
    func HeaderView(_ size: CGSize) -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 5, content: {
                Text("Welcome!")
                    .font(.title.bold())
                if !userName.isEmpty {
                    Text(userName)
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            })
            .visualEffect { content, geometryProxy in
                content.scaleEffect(headerScale(size, prixy: geometryProxy), anchor: .topLeading)
            }
            
            Spacer(minLength: 10)
            
            NavigationLink {
                TransactionView()
            } label: {
                Image(systemName: "plus")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 45, height: 45)
                    .background(
                        Constants.Colors.appTint.gradient,
                        in: .circle
                    )
                    .contentShape(.circle)
            }
        }
        .padding(.bottom, userName.isEmpty ? 10 : 5)
        .background(
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.ultraThinMaterial)
                Divider()
            }
            .visualEffect { content, proxy in
                content.opacity(headerBGOpacity(proxy))
            }
            .padding(.horizontal, -15)
            .padding(.top, -(safeArea.top + 15))
        )
    }
    
    @ViewBuilder
    func CustomSegmentedControl() -> some View {
        HStack(spacing: 0) {
            ForEach(Category.allCases, id: \.rawValue) { category in
                Text(category.rawValue)
                    .hSpacing()
                    .padding(.vertical, 10)
                    .background {
                        if category == selectedCategory {
                            Capsule()
                                .fill(.background)
                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                        }
                    }
                    .contentShape(.capsule)
                    .onTapGesture {
                        withAnimation(.snappy) {
                            selectedCategory = category
                        }
                    }
            }
        }
        .background(.gray.opacity(0.15), in: .capsule)
        .padding(.top, 5)
    }
    
    func headerBGOpacity(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY + safeArea.top
        return minY > 0 ? 0 : (-minY / 15)
    }
    
    func headerScale(_ size: CGSize, prixy: GeometryProxy) -> CGFloat {
        let minY = prixy.frame(in: .scrollView).minY
        let screenHeight = size.height
        let progress = minY / screenHeight
        let scale = (min(max(progress, 0), 1)) * 0.6
        return 1 + scale
    }

}

#Preview {
    ContentView()
}

struct TransactionsList: View {
    
    var transactions: [Transaction]
    var category: Category
    
    var body: some View {
        ForEach(transactions.filter({ $0.category == category.rawValue })) { transaction in
            NavigationLink {
                TransactionView(editTransaction: transaction)
            } label: {
                TransactionCardView(transaction: transaction)
            }
            .buttonStyle(.plain)
        }
    }
}
