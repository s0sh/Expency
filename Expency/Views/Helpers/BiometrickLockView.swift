//
//  BiometrickLockView.swift
//  Expency
//
//  Created by Roman Bigun on 08.01.2025.
//

import SwiftUI

struct BiometrickLockView<Content: View>: View {
    /// Lockk properties
    var lockType: LockType = .number
    var lockPin: String
    var isEnabled: Bool
    var lockWhenAppGoesBackground: Bool = true
    
    @State private var forgotPin: () -> Void = {}
    @State private var animateField: Bool = false
    @State private var isUnlocked: Bool = false
    
    @ViewBuilder var content: Content
    
    /// View Properties
    @State private var pin: String = ""
    
    var body: some View {
        
        GeometryReader {
            let size = $0.size
            
            content
                .frame(width: size.width, height: size.height)
            
            if isEnabled && !isUnlocked {

                ZStack {
                    Rectangle()
                        .ignoresSafeArea()
                    
                    if lockType == .both || lockType == .biometric {
                        
                    } else {
                        /// Custom number pad
                        NumberPadPinView()
                    }
                }
                .transition(.offset(y: size.height + 100))
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
    
    enum LockType: String {
        case biometric = "Bio Metrick Auth"
        case number = "Custom Number Lock"
        case both = "First preference will be biometric and if it's not available it will go for number lock"
    }
}

#Preview {
    TestLock()
}
