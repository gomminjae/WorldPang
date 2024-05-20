//
//  TranslationService.swift
//  WorldPang
//
//  Created by 권민재 on 2023/11/13.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidURL
    case noData
}

class TranslationService {

    let baseURL = "https://openapi.naver.com/v1/papago/n2mt"

    static let shared = TranslationService()

    func translateText(_ text: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
            "X-Naver-Client-Id": "",
            "X-Naver-Client-Secret": ""
        ]

        let parameters: [String: String] = [
            "source": "en",
            "target": "ko",
            "text": text
        ]

        AF.request(url, method: .post, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: TranslationResponse.self) { response in
                switch response.result {
                case .success(let papagoResponse):
                    let translatedText = papagoResponse.message?.result?.translatedText ?? ""
                    completion(.success(translatedText))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
