//
//  ChatView.swift
//  ChatBoxAi
//
//  Created by mido mj on 2/28/25.
//


import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = AIChatViewModel()
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    let userMessage: String

    var body: some View {
        VStack {
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.messages) { message in
                            HStack {
                                if message.isUser { Spacer() }
                                Text(message.text)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(message.isUser ? Color.accentColor : Color.gray)
                                    .cornerRadius(8)
                                if !message.isUser { Spacer() }
                            }
                            .padding(.horizontal)
                            .id(message.id)
                        }
                    }
                }
                .onChange(of: viewModel.messages.count) { 
                    if let lastMessage = viewModel.messages.last {
                        withAnimation {
                            scrollProxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }

            HStack {
                TextField("write_here".localized(), text: $viewModel.userInput)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        viewModel.sendMessage()
                    }

                Button(action: viewModel.sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
            }
            .padding()
        }
        .navigationTitle("chat".localized())
        .direction("en")
//        .environment(\.locale, .init(identifier: appLanguage))
        .onAppear {
            viewModel.addInitialMessage(userMessage)
        }
    }
}

#Preview{
    ChatView(userMessage: "")
}
