//
//  ChatViewModel.swift
//  ChatBoxAi
//
//  Created by mido mj on 2/28/25.
//


import SwiftUI

class AIChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var userInput: String = ""

    func sendMessage() {
        let trimmedInput = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedInput.isEmpty else { return }

        let userMessage = ChatMessage(text: trimmedInput, isUser: true)
        messages.append(userMessage)

        AIChatManager.shared.sendChatRequest(userInput: trimmedInput) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseText):
                    self?.messages.append(ChatMessage(text: responseText, isUser: false))
                case .failure(let error):
                    print("❌ خطأ في جلب الرد:", error.localizedDescription)
                }
            }
        }
        
        userInput = ""
    }
    
    func addInitialMessage(_ message: String) {
        guard !message.isEmpty else { return }
//        messages.append(ChatMessage(text: message, isUser: true))
        userInput = message
        sendMessage()
    }
}
