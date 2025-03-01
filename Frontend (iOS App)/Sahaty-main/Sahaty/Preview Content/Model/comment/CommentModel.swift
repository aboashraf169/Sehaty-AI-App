//
//  Comment.swift
//  Sahaty
//
//  Created by mido mj on 12/14/24.
//


import Foundation


struct DataComment : Codable {
    var data: CommentModel
}

struct CommentModel: Identifiable, Codable {
    var id: Int = 0
    var comment: String = ""
    var article_id: Int = 0
    var img: String? = nil
    var created_at: String = ""
    var updated_at: String = ""
    var user : User = User()
}

struct User: Identifiable, Codable {
    var id: Int = 0
    var name: String = ""
    var email: String = ""
    var img: String? = nil
}
