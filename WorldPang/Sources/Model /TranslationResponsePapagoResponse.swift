//
//  PapagoResponse.swift
//  WorldPang
//
//  Created by 권민재 on 2023/11/16.
//

import Foundation
import ObjectMapper


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
import Foundation

class TranslationResponse: Codable {
    var message: Message?

    class Message: Codable {
        var result: Result?

        class Result: Codable {
            var translatedText: String?
        }
    }
}
