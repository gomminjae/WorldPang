//
//  OCRViewModel.swift
//  WorldPang
//
//  Created by 권민재 on 2023/10/17.
//

import Foundation
import Vision
import VisionKit
import NaturalLanguage
import RxSwift
import RxCocoa
import AVFoundation

class OCRViewModel {
    
    private let disposeBag = DisposeBag()
    
    
    let removedWord = ["the", "she","he","i", "a","an", "we", "they","us","him","am","to","of","in","at", ]
    let text = "The ripe taste of cheese improves with age."
    
    func recognizeText(image: UIImage) {
    }
    
    
}
