//
//  WordManager.swift
//  WorldPang
//
//  Created by 권민재 on 2023/11/26.
//

import Foundation
import Firebase
import RxSwift
import RxCocoa
import FirebaseDatabase

class WordManager {
    private let database = Database.database().reference()
    private let disposeBag = DisposeBag()

    func loadWordsFromFirebase(forPeriod period: Int, completion: @escaping ([VocaDetail]) -> Void) {
        guard period > 0 else {
            print("Invalid period value. It should be greater than 0.")
            completion([])
            return
        }

        let startId = (period - 1) * 100 + 1
        let endId = period * 100

        let query = database.child("words").queryOrdered(byChild: "id").queryStarting(atValue: startId).queryEnding(atValue: endId)

        query.observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion([])
                return
            }

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let vocaDetails = try JSONDecoder().decode([VocaDetail].self, from: jsonData)
                completion(vocaDetails)
            } catch {
                print("Error decoding JSON: \(error)")
                completion([])
            }
        }
    }
}
