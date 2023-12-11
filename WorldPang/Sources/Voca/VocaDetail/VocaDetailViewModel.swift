//
//  VocaDetailViewModel.swift
//  WorldPang
//
//  Created by 권민재 on 11/27/23.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class VocaDetailViewModel {
    
    let vocaDetailRelay = BehaviorRelay<[VocaDetail]>(value: [])
    let realm = try! Realm()
    
    func loadData(row: Int) {
        let fileName = "output_\(row + 1)"
        if let path = Bundle.main.path(forResource: fileName, ofType: "json"),
           let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let vocaDetails = try? JSONDecoder().decode([VocaDetail].self, from: jsonData) {
            // 데이터를 업데이트합니다.
            vocaDetailRelay.accept(vocaDetails)
        } else {
            // 실패할 경우 빈 데이터를 업데이트합니다.
            vocaDetailRelay.accept([])
        }
    }
    
    private func parseJSON(_ json: [String: Any]?) -> VocaDetail? {
        guard let json = json,
              let id = json["id"] as? Int,
              let word = json["word"] as? String,
              let meaning = json["meaning"] as? String,
              let sentence = json["sentence"] as? String,
              let translation = json["translation"] as? String else {
            return nil
        }
        
        return VocaDetail(id: id, word: word, sentence: sentence, meaning: meaning, translation: translation)
    }
    
    
    private func appendWordsToRealm(_ words: [VocaDetail]) {
        try? realm.write {
            for word in words {
                let realmWord = VocaWord()
                realmWord.id = word.id!
                realmWord.word = word.word
                realmWord.meaning = word.meaning
                realmWord.sentence = word.sentence
                realmWord.translation = word.translation
                //realmWord.isKnown = word.isKnown
                                
                realm.add(realmWord, update: .modified)
                
            }
        }
    }
    
    
    
    
    
    
}
