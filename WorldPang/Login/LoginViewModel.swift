//
//  LoginViewModel.swift
//  WorldPang
//
//  Created by 권민재 on 2023/09/22.
//

import Foundation
import RxSwift
import RxCocoa
import KakaoSDKUser
import KakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKUser
import RxKakaoSDKAuth
import RxKakaoSDKCommon
import AuthenticationServices

enum LoginResult {
    case success(token: String)
    case failure(error: Error)
}

protocol LoginViewModelBindable {
    func kakaoLogin()
    func appleLogin()
}

class LoginViewModel: LoginViewModelBindable {
    
    let kakaoLoginResult: PublishSubject<LoginResult> = PublishSubject()
    let appleLoginResult: PublishSubject<LoginResult> = PublishSubject()
    
    public func kakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            loginWithKakaotalk()
        } else {
            loginWithKakaoAccount()
        }
    }
    
    func appleLogin() {
        
    }
    
    
    
    private func loginWithKakaotalk() {
        UserApi.shared.loginWithKakaoTalk { (token, error) in
            if let error = error {
                let result = LoginResult.failure(error: error)
                self.kakaoLoginResult.onNext(result)
                return
            } else {
                if let token = token?.accessToken {
                    let result = LoginResult.success(token: token)
                    self.kakaoLoginResult.onNext(result)
                }
            }
        }
    }
    
    private func loginWithKakaoAccount() {
        
        UserApi.shared.loginWithKakaoAccount { (token, error) in
            if let error = error {
                let result = LoginResult.failure(error: error)
                self.kakaoLoginResult.onNext(result)
                return
            } else {
                if let token = token?.accessToken {
                    let result = LoginResult.success(token: token)
                    self.kakaoLoginResult.onNext(result)
                }
            }
        }
        
    }
    
    
    
    
  
    
    
    
    
}
