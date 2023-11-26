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

class VocaStageViewModel {

    private let disposeBag = DisposeBag()
    private let vocaDetailViewModel = VocaDetailViewModel()
    
    
    var listHomeSection: Observable<[String]> {
        return Observable.of(
            ["Stage 1","Stage 2","Stage 3","Stage 4","Stage 5","Stage 6","Stage 7","Stage 8"]
        )
    }


    private let wordManager = WordManager()

    
    func loadwords(index: Int) {
        wordManager.loadWordsFromFirebase(forPeriod: index) { [ weak self] vocaDetails in
            self?.vocaDetailViewModel.vocaDetailRelay.accept(vocaDetails)
        }
    }

   
}
