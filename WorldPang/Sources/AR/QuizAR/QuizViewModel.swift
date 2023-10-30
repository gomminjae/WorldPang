//
//  QuizViewModel.swift
//  WorldPang
//
//  Created by 권민재 on 2023/10/30.
//

import Foundation
import RxSwift
import RxCocoa

class QuizViewModel: TextNodeDataDelegate {
    
    private let textRelay = BehaviorRelay<String?>(value: nil)
    
    var textObservable: Observable<String?> {
        return textRelay.asObservable()
    }
    
    private let alphabetRelay = BehaviorRelay<[String]>(value: [])

    var alphabetObservable: Observable<[String]> {
        return alphabetRelay.asObservable()
    }
    
    func sendTextNodeString(_ text: String) {
        textRelay.accept(text)
        print(text)
        let alphabetList = text.compactMap { String($0) }
        alphabetRelay.accept(alphabetList)
    }
}
