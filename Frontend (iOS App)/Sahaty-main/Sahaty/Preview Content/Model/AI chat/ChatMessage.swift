//
//  ChatMessage.swift
//  ChatBoxAi
//
//  Created by mido mj on 2/28/25.
//


import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}
