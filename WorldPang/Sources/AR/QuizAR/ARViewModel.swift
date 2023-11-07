//
//  ARViewModel.swift
//  WorldPang
//
//  Created by 권민재 on 2023/10/30.
//

import Foundation
import RxSwift
import RxCocoa



class ARViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let textSubject = BehaviorRelay<String>(value: "")
    
    
    var textNodeObservable: Observable<String> {
        return textSubject.asObservable()
    }
    
    func updateTextNode(_ newValue: String) {
        textSubject.accept(newValue)
    }
    
    
    
    
}
