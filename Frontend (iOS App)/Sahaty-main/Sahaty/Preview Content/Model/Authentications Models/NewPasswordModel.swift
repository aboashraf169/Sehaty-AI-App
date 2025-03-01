//
//  NewPasswordModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation

struct NewPasswordModel: Codable {
    var password: String
    var confirmPassword: String
}

// MARK: - API Request Body
extension NewPasswordModel {
    func toDictionary() -> [String: Any] {
        return [
            "password": password,
            "password_confirmation": confirmPassword
        ]
    }
}
