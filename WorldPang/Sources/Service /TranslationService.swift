//
//  TranslationService.swift
//  WorldPang
//
//  Created by 권민재 on 2023/11/13.
//

import Foundation
import Alamofire


//MARK: 자꾸 디코딩 오류떠서 보류
//class TranslationService {
//    
//    let baseURL = "https://openapi.naver.com/v1/papago/n2mt"
//    
//    static let shared = TranslationService()
//    
//    
//    func translateText(_ text: String, completion: @escaping (Result<String,Error>) -> Void) {
//        
//        let parameters: [String : String] = [
//            "source": "en",
//            "target": "ko",
//            "text": text
//        ]
//        
//        let headers: HTTPHeaders = [
//            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
//            "X-Naver-Client-Id": "OhZagNKjZGIR9_hf5AGp",
//            "X-Naver-Client-Secret": "EVCz3zUZBl"
//        ]
//        
//        AF.request(baseURL, method: .post, parameters: parameters, headers: headers)
//            .validate()
//            .responseDecodable(of: PapagoResponse.self) { response in
//                switch response.result {
//                case .success(let data):
//                    let translatedText = data.translatedText
//                    completion(.success(translatedText))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//        
//        
//    }
//}

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
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("OhZagNKjZGIR9_hf5AGp", forHTTPHeaderField: "X-Naver-Client-Id")
        request.setValue("EVCz3zUZBl", forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let bodyParameters: [String: String] = [
            "source": "en",
            "target": "ko",
            "text": text
        ]
        
        var components = URLComponents()
        components.queryItems = bodyParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        request.httpBody = components.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let papagoResponse = try JSONDecoder().decode(TranslationResponse.self, from: data)
                let translatedText = papagoResponse.message.translatedText.removeNewLines()
                completion(.success(translatedText))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
