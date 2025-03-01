//
//  Post.swift
//  Sahaty
//
//  Created by mido mj on 12/15/24.
//

import Foundation

struct ArticleModel: Identifiable, Codable {
    var id: Int = 0
    var title : String = ""
    var subject: String = ""
    var img: String? = nil
    var doctor: ArticleDoctor = ArticleDoctor()
    var num_comments: Int = 0
    var num_likes: Int = 0
    var created_at: String = ""

    
    // MARK: - API Request Body
    func toDictionary() -> [String : Any] {
        return [
            "title" : title,
            "subject" : subject,
            "img" : img ?? "",
        ]
    }
}

struct ArticleDoctor: Codable {
    var id: Int = 0
    var name: String = ""
    var email: String = ""
    var img: String? = nil
}


struct LinkArticals : Codable {
    var first : String
    var last : String
    var prev : String?
    var next : String?
}


struct linksMeta  : Codable {
    var url : String?
    var label : String
    var active : Bool
}


struct MetaArtical : Codable {
    var current_page : Int
    var from : Int
    var last_page : Int
    var links : [linksMeta]
    var path : String
    var per_page : Int
    var to: Int
    var total : Int
}


struct responseArticals : Codable {
    var data : [ArticleModel]
    var links : LinkArticals
    var meta : MetaArtical
}
