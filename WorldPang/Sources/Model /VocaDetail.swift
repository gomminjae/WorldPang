//
//  Voca.swift
//  WorldPang
//
//  Created by 권민재 on 2023/10/30.
//

import Foundation



struct VocaDetail: Codable {
    
    let id: String?
    let word: String?
    let sentence: String?
    let meaning: String?
    let translation: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, word, sentence, meaning, translation
    }
}
