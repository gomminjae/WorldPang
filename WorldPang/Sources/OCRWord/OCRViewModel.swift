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
    var translatedTextSubject: PublishSubject<String?> { get set }
     
    //func recognizedText(on image: UIImage)
}

class OCRViewModel: OCRViewModelBindable {
    
    
    var selectedImageSubject: PublishSubject<UIImage?> = PublishSubject<UIImage?>()
    var recognizedTextSubject: PublishSubject<String?> = PublishSubject<String?>()
    var translatedTextSubject: PublishSubject<String?> = PublishSubject<String?>()
    
    var ttsString = ""
    var recognizedString = ""
    
    //var recognizedVocaList: [String: String] = [String:String]()
    
    var recognizedVocaListSubject = BehaviorSubject<[String: String]>(value: [String: String]())
    var recognizedVocaList: Observable<[String: String]> {
        return recognizedVocaListSubject.asObservable()
    }
    
    
    private let disposeBag = DisposeBag()
    
    private let papagoService = TranslationService.shared
    private let parsingService = DaumDictionaryService.shared
    
    func recognizedText(on image: UIImage) -> Observable<String> {
        return Observable.create { observer in
            guard let ciImage = CIImage(image: image) else {
                observer.onNext("인식할 단어가 없습니다")
                observer.onCompleted()
                return Disposables.create()
            }
            
            let textRecognitionRequest = VNRecognizeTextRequest { request, error in
                guard let results = request.results as? [VNRecognizedTextObservation], error == nil else {
                    // 텍스트가 인식되지 않았을 때 특정 문자열을 방출합니다.
                    observer.onNext("인식된 텍스트가 없습니다")
                    observer.onCompleted()
                    return
                }
                
                let recognizedText = results.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }.joined(separator: " ")
                
                print("\\\\\\\\\\\\\\\(recognizedText)")
                
                observer.onNext(recognizedText)
                observer.onCompleted()
            }
            
            let textRecognitionRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            do {
                try textRecognitionRequestHandler.perform([textRecognitionRequest])
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func translation(with text: String) {
        
        papagoService.translateText(text) { result in
            switch result {
            case .success(let translatedText):
                self.translatedTextSubject.onNext(translatedText)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getParseVocaList(with text: String) {
        var words: String = text.lowercased()
        let regex = try! NSRegularExpression(pattern: "[^a-z ]", options: .caseInsensitive)
        words = regex.stringByReplacingMatches(in: words, options: [], range: NSRange(location: 0, length: words.utf16.count), withTemplate: "")
        
        let wordsList = words.components(separatedBy: " ")

        // Search Daum Dictionary and update recognizedVocaList
        searchDaumDictionaryObservable(words: wordsList)
            .subscribe(onNext: { result in
                var updatedVocaList = try! self.recognizedVocaListSubject.value()
                for i in 0..<result.means.count {
                    updatedVocaList[result.words[i]] = result.means[i]
                }
                self.recognizedVocaListSubject.onNext(updatedVocaList)
            }, onError: { error in
                // Handle errors
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
    func searchDaumDictionaryObservable(words: [String]) -> Observable<(words: [String], means: [String])> {
        return Observable.create { [self] observer in
            parsingService.searchDaumDictionary(queryKeyword: words.joined(separator: " ")) { words, means in
                observer.onNext((words: words, means: means))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
   







   
    
//    func getParseVocaList(with text: String) {
//        var words: String = text.lowercased()
//        let regex = try! NSRegularExpression(pattern: "[^a-z ]", options: .caseInsensitive)
//        words = regex.stringByReplacingMatches(in: words, options: [], range: NSRange(location: 0, length: words.utf16.count), withTemplate: "")
//        
//        parsingService.searchDaumDictionary(queryKeyword: words) { words,means in
//            for i in 0..<words.count {
//                self.recognizedVocaList[words[i]] = means[i]
//                //print("=======>vocaList\(self.recognizedVocaList)")
//            }
//        }
//    }
}
