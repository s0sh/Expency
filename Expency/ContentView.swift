//
//  ContentView.swift
//  Expency
//
//  Created by Roman Bigun on 07.01.2025.
//

import SwiftUI

struct ContentView: View {
    /// Visibility Status
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
    @State private var activeTab: Tab = .recents
    
    var body: some View {
        TabView(selection: $activeTab) {
            RecentsView()
                .tag(Tab.recents)
                .tabItem { Tab.recents.tabContent }
            SearchView()
                .tag(Tab.filter)
                .tabItem { Tab.filter.tabContent }
            ChartsView()
                .tag(Tab.charts)
                .tabItem { Tab.charts.tabContent }
            SettingsView()
                .tag(Tab.settings)
                .tabItem { Tab.settings.tabContent }
        }
        .tint(Constants.Colors.appTint)
        .sheet(isPresented: $isFirstTime, content:  {
            IntroScreen()
                .interactiveDismissDisabled()
        })
    }
}

#Preview {
    ContentView()
}

