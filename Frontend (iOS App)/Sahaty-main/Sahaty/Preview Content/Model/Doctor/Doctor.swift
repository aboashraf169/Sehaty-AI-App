//
//  Doctor.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//

import Foundation


struct DoctorModel: Identifiable, Codable {
    
    var id: Int = 0
    var name:String = "defult"
    var email:String = "defult@gmail.com"
    var bio: String? = nil
    var img: String? = nil
    var jopSpecialtyNumber: String = "00000"
    
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, bio, img
        case jopSpecialtyNumber = "jop_specialty_number"
    }
    
    
    // MARK: - API Request Body
    func toDectinary() -> [String : Any] {
        return [
            "name" : name,
            "email" : email,
            "bio" : bio ?? "",
            "jop_specialty_number" : jopSpecialtyNumber,
        ]
    }
    
  
}
struct Response: Codable {
    let message: String
    let user: DoctorModel
}

struct ResponseSpeciatyDoctor: Codable {
    let data: [DoctorModel]
}

struct DoctorInfoData : Codable{
    var doctor_name : String = ""
    var doctor_img : String = ""
    var number_of_followers : Int = 0
    var number_of_articles : Int = 0
    var number_of_advice : Int = 0
}
