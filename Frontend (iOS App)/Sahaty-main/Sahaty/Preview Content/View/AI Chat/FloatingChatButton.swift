//
//  FloatingChatButton.swift
//  ChatBoxAi
//
//  Created by mido mj on 2/28/25.
//


import SwiftUI

struct FloatingChatButton: View {
    @State private var showTextField = false
    @State private var userInput: String = ""
    @State private var navigateToChat = false

    
    var body: some View {
//        NavigationStack {
//            ZStack {
//                VStack { Spacer() }

//                VStack {
//                    Spacer()
                    HStack {
//                        Spacer()
                        if showTextField {
                            TextField("write_here".localized(), text: $userInput)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(8)
//                                .background(Color.white)
                                .cornerRadius(10)
                                .transition(.move(edge: .leading))
                        }

                        Button(action: {
                            withAnimation {
                                if showTextField && !userInput.isEmpty {
                                    navigateToChat = true
//                                    showTextField = false

                                } else {
                                    showTextField.toggle()
                                }
                            }
                        }) {
                            Image(systemName: showTextField ? "paperplane.fill" : "message.fill")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.accentColor)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                    }
                    .padding(.horizontal)
//                    .background(Color.blue)
                    .onAppear{
                        userInput = ""
                       showTextField = false

                    }
//                }
//            }
            .navigationDestination(isPresented: $navigateToChat) {
                ChatView(userMessage: userInput)
            }
//        }
    }
}

#Preview {
    FloatingChatButton()
}
