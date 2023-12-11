//
//  VocaDetailViewModel.swift
//  WorldPang
//
//  Created by 권민재 on 11/27/23.
//

import Foundation
import RxSwift
import RxCocoa


class VocaDetailViewModel {
    
    let vocaDetailRelay = BehaviorRelay<[VocaDetail]>(value: [])
    
    func loadData(row: Int) {
        if let path =  Bundle.main.path(forResource: "output_\(row+1)", ofType: "json"),
           let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
           let vocaDetail = parseJSON(json) {
            // 데이터를 업데이트합니다.
            vocaDetailRelay.accept([vocaDetail])
        } else {
            // 실패할 경우 빈 데이터를 업데이트합니다.
            vocaDetailRelay.accept([])
        }
    }
    private func parseJSON(_ json: [String: Any]?) -> VocaDetail? {
        guard let json = json,
              let id = json["id"] as? String,
              let word = json["word"] as? String,
              let sentence = json["sentence"] as? String,
              let meaning = json["meaning"] as? String,
              let translation = json["translation"] as? String else {
            return nil
        }
        
        return VocaDetail(id: id, word: word, sentence: sentence, meaning: meaning, translation: translation)
    }
    
    
    
    let dummydata = [
        VocaDetail(id: "1", word: "a", sentence: "하나의", meaning: "There's a telephone call for you.", translation: "당신에게 온 전화가 하나 있어요."),
        VocaDetail(id: "3", word: "academy", sentence: "-보다 위에", meaning: "There's a telephone call for you.", translation: "달이 구름 위에 걸려있다."),
        VocaDetail(id: "4", word: "academy", sentence: "학원", meaning: "Which do you think is better, school or academy?", translation: "학교랑 학원 중 어느 게 더 좋다고 생각해?"),
        VocaDetail(id: "5", word: "accent", sentence: "말투", meaning: "The transfer student spoke in a Seoul accent.", translation: "전학 온 아이는 서울말을 썼다."),
        VocaDetail(id: "6", word: "accident", sentence: "사건", meaning: "This is an accident rarely met with.", translation: "이것은 보기 드문 사건이다.")
    ]
    
    
}
