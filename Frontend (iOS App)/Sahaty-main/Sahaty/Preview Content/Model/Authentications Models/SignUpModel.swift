//
//  SignUpModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation

// MARK: - SignUpModel
struct SignUpModel: Codable {  
    var name: String
    var email: String
    var password : String
    var password_confirmation : String
    var usersType: UsersType
    var jop_specialty_number: String?
    var specialty_id: String?
    
    // MARK: - API Request Body
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "email": email,
            "password": password,
            "password_confirmation": password_confirmation,
            "is_doctor": usersType == .doctor ? true : false,
            "jop_specialty_number": jop_specialty_number ?? "0",
            "specialty_id": specialty_id ?? "10"
        ]
         
    }
    
    func toDictionaryPatient() -> [String: Any] {
        return [
            "name": name,
            "email": email,
            "password": password,
            "password_confirmation": password_confirmation,
            "is_doctor": usersType == .doctor ? true : false,
        ]
         
    }
    
}






