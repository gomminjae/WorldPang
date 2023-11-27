//
//  VocaParsingManager.swift
//  WorldPang
//
//  Created by 권민재 on 2023/11/06.
//

import Foundation
import SwiftSoup
import RxSwift
import RxAlamofire


protocol ParsingProtocol {

    func getVocaData(_ word: String)
    
}

class VocaParsingManager: ParsingProtocol {
    
    func getVocaData(_ word: String) {
        let baseURL = "https://en.dict.naver.com/#/search?query=\(word)"
        
        
    }
    
    
}
