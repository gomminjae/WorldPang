//
//  PapagoResponse.swift
//  WorldPang
//
//  Created by 권민재 on 2023/11/16.
//

import Foundation


//struct PapagoResponse: Codable {
//    let translatedText: String
//    let srcLangType: String
//    let tarLangType: String
//    
//    private enum CodingKeys: String, CodingKey {
//        case translatedText
//        case srcLangType
//        case tarLangType
//    }
//}
struct TranslationResponse: Codable {
    let message: Result
    
    struct Result: Codable {
//        let srcLangType: String
//        let tarLangType: String
        let translatedText: String
        //let engineType: String
    }
}
