//
//  VocaViewModel.swift
//  WorldPang
//
//  Created by 권민재 on 2023/10/16.
//

import Foundation
import RxSwift
import RxDataSources


class VocaListViewModel {
    
    let disposeBag = DisposeBag()
    
    let vocaSubject = BehaviorSubject<[Voca]>(value: [])
    
    init() {
        
        fetchVocaJson()
            .subscribe(onNext: { [weak self] vocaArray in
                self?.vocaSubject.onNext(vocaArray)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchVocaJson() -> Observable<[Voca]> {
        return Observable.create { observer in
            if let path = Bundle.main.path(forResource: "BasicVoca", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path))
                    let decoder = JSONDecoder()
                    
                    let vocaArray = try decoder.decode([Voca].self, from: data)
                    
                    observer.onNext(vocaArray)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            } else {
                observer.onError(NSError(domain: "FileNotFoundError", code: 0, userInfo: nil))
            }
            
            return Disposables.create()
        }
    }
    
    func getFirst20Items(from vocaArray: [Voca]) -> Observable<[Voca]> {
        return Observable.just(Array(vocaArray.prefix(20)))
    }
    
    
    
}
