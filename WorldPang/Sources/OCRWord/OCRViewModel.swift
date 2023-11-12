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

//protocol OCRViewModelBindable {
//    
//    var recognizedText: String { get  }
//    
//    func recognizeText(image: UIImage)
//}

class OCRViewModel {
    
    var recognizedText: String = String()
    
    let selectedImageSubject = PublishSubject<UIImage?>()
    
    
    private let disposeBag = DisposeBag()

    
//    func recognizeText(image: UIImage) {
//        
//        guard let ciImage = CIImage(image: image) else { recognizedText = ""
//            return }
//        
//        
//        let request = VNRecognizeTextRequest { request, error  in
//            guard let observations = request.results as? [VNRecognizedText] else { return }
//            
//            let textRecognitionQue = DispatchQueue(label: "textRecognition")
//            
//            let requestHandler = VNImageRequestHandler(ciImage: ciImage)
//            
//            do {
//                try requestHandler.perform([request], on: textRecognitionQue)
//            } catch {
//                
//            }
//            
//        }
//    }
    
    
    
    
}
