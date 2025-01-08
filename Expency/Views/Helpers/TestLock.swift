//
//  TestLock.swift
//  Expency
//
//  Created by Roman Bigun on 08.01.2025.
//

import SwiftUI

struct TestLock: View {
    var body: some View {
        BiometrickLockView(lockType: .number, lockPin: "3232", isEnabled: true) {
            Text("Hello, World!")
        }
    }
}

#Preview {
    TestLock()
}
