//
//  OCRViewModel.swift
//  WorldPang
//
//  Created by 권민재 on 2023/10/17.
//

import UIKit
import Vision
import RxSwift
import RxCocoa

protocol OCRViewModelBindable {
    var selectedImageSubject: PublishSubject<UIImage?> { get set }
    var recognizedTextSubject: PublishSubject<String?> { get set }
    
    func recognizedText(on image: UIImage)
}

class OCRViewModel: OCRViewModelBindable {
    
    var selectedImageSubject: PublishSubject<UIImage?> = PublishSubject<UIImage?>()
    var recognizedTextSubject: PublishSubject<String?> = PublishSubject<String?>()
    
    
    private let disposeBag = DisposeBag()

    
    //UIImage -> CIImage -> VNRequsr coreml방식이랑 비슷함
    func recognizedText(on image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            recognizedTextSubject.onNext(nil)
            return
        }
        
        let textRecognitionRequest = VNRecognizeTextRequest { [weak self] request, error in
            guard let results = request.results as? [VNRecognizedTextObservation], error == nil else {
                self?.recognizedTextSubject.onNext(nil)
                return
            }
            
            let recognizedText = results.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.joined(separator: "\n")
            
            self?.recognizedTextSubject.onNext(recognizedText)
        }
        
        let textRecognitionRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        do {
            try textRecognitionRequestHandler.perform([textRecognitionRequest])
        } catch {
            recognizedTextSubject.onNext(nil)
        }
        
        
    }
}
