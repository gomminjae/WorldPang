//
//  ParsingSystem.swift
//  WorldPang
//
//  Created by 권민재 on 11/27/23.
//

import Foundation
import SwiftSoup


//class DaumDictionaryService {
//    static let shared = DaumDictionaryService()
//
//    func searchDaumDictionary(queryKeyword: String, completion: @escaping (String, [String]) -> Void) {
//        let dicURL = "https://dic.daum.net/search.do?q=\(queryKeyword)"
//        
//        guard let url = URL(string: dicURL) else {
//            completion("", [])
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard error == nil, let data = data, let html = String(data: data, encoding: .utf8) else {
//                completion("", [])
//                return
//            }
//
//            do {
//                let doc = try SwiftSoup.parse(html)
//
//                // 첫 번째 select
//                if let firstInfo = try? doc.select(" [class*=txt_emph1]") {
//                    let firstResult = try firstInfo.array().compactMap { try? $0.text().trimmingCharacters(in: .whitespacesAndNewlines) }
//                    // 두 번째 select
//                    if let secondInfo = try? doc.select("[class*=list_search]") {
//                        let secondResult = secondInfo.array().compactMap { try? $0.text().trimmingCharacters(in: .whitespacesAndNewlines) }
//                        let secondResults = secondResult[0].components(separatedBy: " ")
//                        
//                        // 결과 전달
//                        completion(firstResult[0], secondResults )
//                    } else {
//                        completion("", [])
//                    }
//                } else {
//                    completion("", [])
//                }
//            } catch {
//                completion("", [])
//            }
//        }
//        
//        task.resume()
//    }
//}
class DaumDictionaryService {
    static let shared = DaumDictionaryService()

    func searchDaumDictionary(queryKeyword: String, completion: @escaping (String, [String]) -> Void) {
        let dicURL = "https://dic.daum.net/search.do?q=\(queryKeyword)&dic=eng"

        guard let url = URL(string: dicURL) else {
            completion("", [])
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data, let html = String(data: data, encoding: .utf8) else {
                completion("", [])
                return
            }

            do {
                let doc = try SwiftSoup.parse(html)

                if let (firstResult, secondResult) = try? self.extractResults(from: doc, firstSelector: "[class*=txt_emph1]", secondSelector: "[class*=list_search]") {
                    completion(firstResult, secondResult)
                } else {
                    completion("", [])
                }
            } catch {
                completion("", [])
            }
        }

        task.resume()
    }

    private func extractResults(from document: Document, firstSelector: String, secondSelector: String) throws -> (String, [String]) {
        let firstElements = try document.select(firstSelector).array()
        let firstResult = firstElements.compactMap { try? $0.text().trimmingCharacters(in: .whitespacesAndNewlines) }.first ?? ""

        let secondElements = try document.select(secondSelector).array()
        let secondResult = secondElements.compactMap { try? $0.text().trimmingCharacters(in: .whitespacesAndNewlines) }

        return (firstResult, secondResult)
    }
}
