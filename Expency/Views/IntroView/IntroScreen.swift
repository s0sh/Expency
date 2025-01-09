//
//  IntroScreen.swift
//  Expency
//
//  Created by Roman Bigun on 07.01.2025.
//

import SwiftUI

struct IntroScreen: View {
    /// Visibility Status
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
    var body: some View {
        VStack(spacing: 15) {
            Text("What's New in the\nExpence Trecker")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 65)
                .padding(.bottom, 35)
            
            /// Points view
            VStack(alignment: .leading, spacing: 25, content: {
                PointsView(symbol: "dollarsign.circle",
                           title: "Transactions",
                           subTitle: "Keep track of your earnings and expences.")
                PointsView(symbol: "chart.bar.fill",
                           title: "Visual Charts",
                           subTitle: "View your transation using eye-catching graphic representation.")
                PointsView(symbol: "magnifyingglass",
                           title: "Advance Filters",
                           subTitle: "Find the expences you want by advance search and filtering.")
                
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 25)
            
            Spacer(minLength: 10)
            
            Button(action: {
                // Add haptic feedback
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    isFirstTime = false
                }
            }) {
                Text("Continue")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 20)
                    .background(Constants.Colors.appTint.gradient, in: RoundedRectangle(cornerRadius: 12))
            }
            .pressAnimation()
            .padding(.horizontal, 20)
        }
        .padding(15)
        
    }
    /// Point view
    @ViewBuilder
    func PointsView(symbol: String, title: String, subTitle: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(Constants.Colors.appTint.gradient) // Changed appTint to Color.blue since appTint is not defined
                .frame(width: 45)
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(subTitle)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    IntroScreen()
}
