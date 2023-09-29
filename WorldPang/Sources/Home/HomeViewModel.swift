//
//  HomeViewModel.swift
//  WorldPang
//
//  Created by 권민재 on 2023/09/29.
//

import Foundation
import RxSwift
import RxAlamofire

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(_ input: Input)
    
    
}


