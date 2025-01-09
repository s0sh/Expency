//
//  BiometrickLockView.swift
//  Expency
//
//  Created by Roman Bigun on 08.01.2025.
//

import SwiftUI
import LocalAuthentication

struct BiometrickLockView<Content: View>: View {
    
    enum LockType: String {
        case biometric = "Bio Metrick Auth"
        case number = "Custom Number Lock"
        case both = "First preference will be biometric and if it's not available it will go for number lock"
    }

    /// Lockk properties
    var lockType: LockType = .number
    var lockPin: String
    var isEnabled: Bool
    var lockWhenAppGoesBackground: Bool = true
    
    @State private var noBiometricAccess: Bool = false
    @State private var forgotPin: () -> Void = {}
    @State private var animateField: Bool = false
    @State private var isUnlocked: Bool = false
    
    @State private var context = LAContext()
    
    @Environment(\.scenePhase) private var phase
    
    @ViewBuilder var content: Content
    
    /// View Properties
    @State private var pin: String = ""
    
    var body: some View {
        
        GeometryReader {
            
            let size = $0.size
            
            content.frame(width: size.width, height: size.height)
            
            if isEnabled && !isUnlocked {

                ZStack {
                    Rectangle()
                        .fill(.black)
                        .ignoresSafeArea()
                    
                    if (lockType == .both && !noBiometricAccess) || lockType == .biometric {
                        /// Bio Metric section
                        biometricSection
                    } else {
                        /// Custom number pad
                        NumberPadPinView()
                    }
                }
                .environment(\.colorScheme, .dark)
                .transition(.offset(y: size.height + 100))
                
            }
        }
        .onChange(of: isEnabled, initial: true) { oldValue, newValue in
            if newValue {
                unlockView()
            }
        }
        /// Locking when app goes background
        .onChange(of: phase) { oldValue, newValue in
            if newValue != .active && lockWhenAppGoesBackground {
                isUnlocked = false
                pin = ""
            }
            
            // Avoid unnesesary FaceID popup by cross checking
            if newValue == .active && !isUnlocked && isEnabled {
                unlockView()
            }
        }
    }
   
}

//#Preview {
//    TestLock()
//}


extension BiometrickLockView {
    
    private var isBiometricAvailable: Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    private func unlockView() {
        /// Checking and ulocking view
        Task {
            if isBiometricAvailable && lockType != .number {
                if let result = try? await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlocking the View"), result {
                    print("Unlocked!")
                    withAnimation(.snappy, completionCriteria: .logicallyComplete) {
                        isUnlocked = true
                    } completion: {
                        pin = ""
                    }
                }
            }
            noBiometricAccess = !isBiometricAvailable
        }
    }
    
    var biometricSection: some View {
        Group {
            if noBiometricAccess {
                Text("Enable biometric access in settings to unlock the view.")
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .padding(50)
            } else {
                /// Bio metric / pin unlock
                VStack(spacing: 12) {
                    VStack(spacing: 6) {
                        Image(systemName: "lock")
                            .font(.largeTitle)
                              
                        Text("Tap to Unlock")
                            .font(.caption2)
                            .foregroundStyle(.gray)
                    }
                    .frame(width: 100, height: 100)
                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                    .contentShape(.rect)
                    .onTapGesture {
                        unlockView()
                    }
                    
                    if lockType == .both {
                        Text("Enter Pin")
                            .frame(width: 100, height: 40)
                            .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                            .contentShape(.rect)
                            .onTapGesture {
                                noBiometricAccess = true
                            }
                    }
                }
            }
        }
    }
    
    /// Custom number pad pin view
    @ViewBuilder
    func NumberPadPinView() -> some View {
        
        VStack(spacing: 15) {
            Text("Enter Pin")
                .font(.title.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    /// Back button only for both lock types
                    if lockType == .both  && isBiometricAvailable {
                        Button(action: {
                            pin = ""
                            noBiometricAccess = false
                        }, label: {
                            Image(systemName: "arrow.left")
                                .font(.title3)
                                .contentShape(.rect)
                        })
                        .tint(.white)
                        .padding(.leading)
                    }
                }
            Spacer()
            
            /// Adding wiggling animation for wwrong password using Keyframe animator
            HStack(spacing: 10) {
                ForEach(0..<4, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 55)
                        /// Showing pin at each box with the help of Index
                        .overlay {
                            if pin.count > index {
                                let index = pin.index(pin.startIndex, offsetBy: index)
                                let string = String(pin[index])
                                Text(string)
                                    .font(.title.bold())
                                    .foregroundStyle(.black)
                            }
                        }
                }
                
            }
            .keyframeAnimator(initialValue: CGFloat.zero,
                              trigger: animateField,
                              content: { content, value in
                content.offset(x: value)
            }, keyframes: { _ in
                KeyframeTrack {
                    CubicKeyframe(30, duration: 0.07)
                    CubicKeyframe(-30, duration: 0.07)
                    CubicKeyframe(20, duration: 0.07)
                    CubicKeyframe(-30, duration: 0.07)
                    CubicKeyframe(0, duration: 0.07)
                }
            })
            
            .padding(.top, 150)
            .overlay(alignment: .bottomTrailing, content: {
                Button("Forgot Pin?", action: forgotPin)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .offset(y: 40)
            })
            .frame(maxWidth: .infinity)
            
            Spacer()
            /// Custom number pad
            GeometryReader { _ in
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), content: {
                    ForEach(1..<10, id: \.self) { number in
                        Button(action: {
                            if pin.count < 4 {
                                pin.append("\(number)")
                            }
                        }, label: {
                            Text("\(number)")
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .contentShape(.rect)
                        })
                        .tint(.white)
                    }
                    
                    Button(action: {
                        if !pin.isEmpty {
                            pin.removeLast()
                        }
                    }, label: {
                        Image(systemName: "delete.backward")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .contentShape(.rect)
                    })
                    .tint(.white)
                    
                    Button(action: {
                        if pin.count < 4 {
                            pin.append("\(0)")
                        }
                    }, label: {
                        Text("\(0)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .contentShape(.rect)
                    })
                    .tint(.white)
                    
                })
                .frame(maxWidth: .infinity, alignment: .bottom)
            }
            .padding(.top, 75)
            .onChange(of: pin) { oldValue, newValue in
                if newValue.count == 4 {
                    /// Validate Pin
                    if lockPin == pin {
                        print("Unlocked")
                        withAnimation(.snappy, completionCriteria: .logicallyComplete) {
                            isUnlocked = true
                        } completion: {
                         /// Creating Pin
                            pin = ""
                            noBiometricAccess = !isBiometricAvailable
                        }
                    } else {
                        print("Wrorng pin")
                        pin = ""
                        animateField.toggle()
                    }
                }
            }
            
        }
        .padding()
        .environment(\.colorScheme, .dark)
    }
}
