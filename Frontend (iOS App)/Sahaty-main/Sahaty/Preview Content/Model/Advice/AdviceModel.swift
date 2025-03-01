//
//  AdviceModel.swift
//  Sahaty
//
//  Created by mido mj on 12/14/24.
//

import Foundation

struct AdviceModel: Identifiable, Codable {
    var id: Int = 0
    var advice: String = ""
    
    // MARK: - API Request Body
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "advice": advice
        ]
    }
    enum CodingKeys: String, CodingKey {
        case id
        case advice
    }
}

struct ResponseAdvice : Codable{
    let data: [AdviceModel]
    let links : AdviceLink
    let meta : Meta
}

struct ResponAddUpdateAdvice : Codable{
    let data: AdviceModel
}

struct AdviceLink: Codable {
    let first: String
    let last: String
    let prev: Int?
    let next: String?
}

struct Meta : Codable{
    var current_page : Int
    var from : Int
    var last_page : Int
    var links : [Link]
    var path : String
    var per_page : Int
    var to : Int
    var total : Int
}
struct Link: Codable {
    let url: String?
    let label: String
    let active: Bool
}
