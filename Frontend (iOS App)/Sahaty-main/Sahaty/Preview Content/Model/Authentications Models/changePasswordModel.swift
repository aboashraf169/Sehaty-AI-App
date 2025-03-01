//
//  NewPasswordModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation


struct changePasswordModel: Codable {
    var old_password: String
    var password: String
    var confirmPassword: String
}

// MARK: - API Request Body
extension changePasswordModel {
    func toDictionary() -> [String: Any] {
        return [
            "last_password": old_password,
            "password": password,
            "password_confirmation": confirmPassword
        ]
    }
}
