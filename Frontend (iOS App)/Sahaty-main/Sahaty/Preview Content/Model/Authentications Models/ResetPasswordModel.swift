//
//  ResetPasswordModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation

struct ResetPasswordModel: Codable {
    var email: String
    var newPassword: String
    var confirmPassword: String
    
    // MARK: - API Request Body
    func toDictionary() -> [String: Any] {
        return [
            "new_password": newPassword,
            "password_confirmation": confirmPassword
        ]
    }

}




