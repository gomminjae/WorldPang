//
//  HomeViewModel.swift
//  WorldPang
//
//  Created by 권민재 on 2023/09/29.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(_ input: Input)
    
}
enum Stage {
    case virtual
    case reality
    case space
}

class HomeViewModel {
    
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    var userInfo =  PublishSubject<User>()
    
    var nickname = ""
  
    
    let dummyData = ["AR", "MAP", "SPACE","CITY"]
    
  
    
    
    func debug(_ user: User) {
        print("디버깅: ----  \(user.nickname)")
        userInfo.onNext(user)
    }

    
    
    
    
}


