//
//  QuizViewModel.swift
//  WorldPang
//
//  Created by 권민재 on 2023/11/13.
//

import Foundation
import RxSwift
import RxCocoa

protocol QuizViewModelBindable {
    //input
    var selectedIndexPath: PublishSubject<IndexPath> { get }
    var summitButtonTapped: PublishSubject<Void> { get }
    
    //output
    var shuffledLetters: Observable<[String]> { get }
    var isSelectionEnabled: Observable<Bool> { get }
}

class QuizViewModel: QuizViewModelBindable {
    
    
    var selectedIndexPath: PublishSubject<IndexPath> = PublishSubject<IndexPath>()
    var summitButtonTapped: PublishSubject<Void> = PublishSubject<Void>()
    
    var shuffledLetters: Observable<[String]>
    var isSelectionEnabled: Observable<Bool>
    
    
    private let disposeBag = DisposeBag()
    
    init(textNodeString: Observable<String>) {
        
        shuffledLetters = textNodeString
            .map {$0.replacingOccurrences(of: " ", with: "").map { String($0) }
            .shuffled()}
        
        isSelectionEnabled = selectedIndexPath
            .map { _ in true }
            .startWith(true)
        
    }
    
    
}
