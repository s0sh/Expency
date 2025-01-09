//
//  ExpencyApp.swift
//  Expency
//
//  Created by Roman Bigun on 07.01.2025.
//

import SwiftUI

@main
struct ExpencyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Transaction.self])
    }
}
