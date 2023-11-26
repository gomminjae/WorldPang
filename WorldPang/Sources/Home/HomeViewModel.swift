//
//  HomeViewModel.swift
//  WorldPang
//
//  Created by 권민재 on 2023/09/29.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    func transform(_ input: Input)
    
}

class HomeViewModel {
    
    var userInfo: BehaviorSubject<User?> = BehaviorSubject(value: nil)
    
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    
    var nickname = ""
    let dummyData = ["AR", "MAP", "SPACE","CITY"]
    
    var stageObservable: Observable<[Stage]> {
        return Observable.of([
            Stage(title: "Ar 단어 공부", content: "물건을 촬영하여\n영어단어를 학습하세요!", stageType: .normal),
            
            Stage(title: "AR Solar System", content: "AR환경에서 \n느끼는 태양계!", stageType: .space),
            
            Stage(title: "AR Aquarium 단어 공부", content: "아쿠아리움에서, \n특별한 단어 공부!!", stageType: .aquarium)
        ])
    }
    
    init() {
        loadUserInfo()
    }
    
    
    private func loadUserInfo() {
        if let userInfo = UserDefaults.standard.data(forKey: "User"),
           let user = try? JSONDecoder().decode(User.self, from: userInfo) {
            self.userInfo.onNext(user)
            
        }
    }
    
    func loadProfileImage(urlString: URL?, completion: @escaping (UIImage?) -> Void) {
        if let url = urlString {
            URLSession.shared.dataTask(with: url) { data,_,error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil)
                    return
                }
                
                if let data = data,
                   let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
            .resume()
        } else {
            completion(nil)
        }
    }
    
}


