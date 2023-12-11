//
//  Voca.swift
//  WorldPang
//
//  Created by 권민재 on 2023/10/30.
//

import Foundation
import RealmSwift



struct VocaDetail: Codable {
    let id: Int?
    let word: String
    let sentence: String
    let meaning: String
    let translation: String
}

class VocaWord: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var word: String = ""
    @objc dynamic var meaning: String = ""
    @objc dynamic var sentence: String = ""
    @objc dynamic var translation: String = ""
    @objc dynamic var isKnown: Bool = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
}


