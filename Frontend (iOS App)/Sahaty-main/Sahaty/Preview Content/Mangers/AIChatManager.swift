//
//  ChatManager.swift
//  ChatBoxAi
//
//  Created by mido mj on 2/28/25.
//


import Foundation

class AIChatManager {
    static let shared = AIChatManager()
    
    private init() {}

    func sendChatRequest(userInput: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let encodedInput = userInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "EncodingError", code: 400, userInfo: [NSLocalizedDescriptionKey: "فشل في ترميز المدخلات"])))
            return
        }
        
        let urlString = "http://localhost:8001/chat?user_input=\(encodedInput)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "URLError", code: 400, userInfo: [NSLocalizedDescriptionKey: "الرابط غير صحيح"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let stringResponse = String(data: data, encoding: .utf8) else {
                completion(.failure(NSError(domain: "ResponseError", code: 500, userInfo: [NSLocalizedDescriptionKey: "استجابة غير صالحة"])))
                return
            }

            completion(.success(stringResponse))
        }
        
        task.resume()
    }
}
