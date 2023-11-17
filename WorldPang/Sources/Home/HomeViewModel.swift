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
enum Stage {
    case virtual
    case reality
    case space
}

class HomeViewModel {
    
    var userInfo: BehaviorSubject<User?> = BehaviorSubject(value: nil)
    
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    
    var nickname = ""
  
    let dummyData = ["AR", "MAP", "SPACE","CITY"]
    
    
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


