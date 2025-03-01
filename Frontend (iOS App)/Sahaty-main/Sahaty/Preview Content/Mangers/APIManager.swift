//
//  APIManager.swift
//  Sahaty
//
//  Created by mido mj on 1/11/25.
//


import Foundation
import SwiftUI

class APIManager {
    
    static let shared = APIManager()
    private let baseURL = "http://127.0.0.1:8000/api"
    var bearerToken: String?
    
    // MARK: - Set Bearer Token
    func setBearerToken(_ token: String) {
        self.bearerToken = token
    }
    
    // MARK: - Send Request
    func sendRequest(
        endpoint: String,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Add Bearer Token if available
        if let token = bearerToken {
            print("Bearer Token being sent: \(token)")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Add parameters for POST/PUT requests
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }else{
            print("error")
        }
        
        
        print("Request URL: \(request.url?.absoluteString ?? "")")
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        print("Request Body: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "error reading Request Body")")
        
        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(APIError.serverError(message: "serverError")))
                return
            }
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                let message = response.statusCode == 401 ? "Unauthorized" : "Server Error"
                completion(.failure(APIError.serverError(message: message)))
                print("Status Code: \(response.statusCode)")
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
    
    
    
    // MARK: - Create Multipart Body
    func createMultipartBody(parameters: [String: String], image: UIImage, boundary: String) -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        if let imageData = image.jpegData(compressionQuality: 0.7) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"img\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }

    
}



// MARK: - HTTPMethod Enum
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}



// MARK: - APIError Enum
enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case serverError(message: String) 
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid."
        case .noData:
            return "No data received from the server."
        case .decodingError:
            return "Failed to decode the response."
        case .serverError(let message):
            return message
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
