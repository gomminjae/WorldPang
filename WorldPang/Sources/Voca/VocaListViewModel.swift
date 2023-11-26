//
//  VocaViewModel.swift
//  WorldPang
//
//  Created by 권민재 on 2023/10/16.
//

import Foundation
import RxSwift
import RxDataSources
import FirebaseDatabase
import RxCocoa

class VocaListViewModel {

    private let disposeBag = DisposeBag()
    let dailyLearnedVocaRelay = BehaviorRelay<[VocaDetail]>(value: [])
    
    let ListHomeSection = ["Stage 1","Stage 2","Stage 3","Stage 4","Stage 5","Stage 6","Stage 7","Stage 8"]


    private let wordManager = WordManager()

    init() {
        wordManager.loadWordsFromFirebase(forPeriod: 0) { [ weak self] vocaDetails in
            self?.dailyLearnedVocaRelay.accept(vocaDetails)
        }
    }
    
    func loadwords(index: Int) {
        wordManager.loadWordsFromFirebase(forPeriod: index) { [ weak self] vocaDetails in
            self?.dailyLearnedVocaRelay.accept(vocaDetails)
        }
    }

   
}
