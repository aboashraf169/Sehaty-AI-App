//
//  File.swift
//  Sahaty
//
//  Created by mido mj on 1/22/25.
//

import Foundation

struct spectialties : Identifiable , Codable, Hashable{
    var id: Int = 0
    var name: String = ""
}
struct dataSpectialties: Codable {
    let data: [spectialties]
}
