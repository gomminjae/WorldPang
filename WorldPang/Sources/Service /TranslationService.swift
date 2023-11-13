//
//  TranslationService.swift
//  WorldPang
//
//  Created by 권민재 on 2023/11/13.
//

import Foundation
import Alamofire

struct PapagoResponse: Codable {
    let resultText: String
}


class TranslationService {
    
    let baseURL = "https://openapi.naver.com/v1/papago/n2mt"
    
    static let shared = TranslationService()
    
    
    func translateText(_ text: String, completion: @escaping (Result<String,Error>) -> Void) {
        
        let parameters: [String : Any] = [
            "source": "en",
            "target": "ko",
            "text": text
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
            "X-Naver-Client-Id": "OhZagNKjZGIR9_hf5AGp",
            "X-Naver-Client-Secret": "EVCz3zUZBl"
        ]
        
        AF.request(baseURL, method: .post, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: PapagoResponse.self) { response in
                switch response.result {
                case .success(let papagoResponse):
                    let translatedText = papagoResponse.resultText
                    completion(.success(translatedText))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        
    }
}
