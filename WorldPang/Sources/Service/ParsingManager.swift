//
//  ParsingSystem.swift
//  WorldPang
//
//  Created by 권민재 on 11/27/23.
//

import Foundation
import SwiftSoup
import RxSwift
import RxCocoa

class ParsingManager {
    
    static let shared = ParsingManager()
    
    func getMeaningAndSentence(forQuery query: String) {
        let url = "https://en.dict.naver.com/#/search?query=\(query)"
        guard let naverURL = URL(string: url) else {
            fatalError("Invalid URL")
        }

        do {
            let html = try String(contentsOf: naverURL)
            let doc = try SwiftSoup.parse(html)

            if let meaningElement = try doc.select(".mean").first() {
                let meaning = try meaningElement.text()
                print("Meaning: \(meaning)")
            } else {
                print("Meaning not found")
            }

            if let sentenceElement = try doc.select(".example em").first() {
                let sentence = try sentenceElement.text()
                print("Sentence: \(sentence)")
            } else {
                print("Sentence not found")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
