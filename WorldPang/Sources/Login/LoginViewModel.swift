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

class LoginViewModel: NSObject, LoginViewModelBindable {
    
    private let disposeBag = DisposeBag()
    
    let kakaoLoginResult: PublishSubject<LoginResult> = PublishSubject()
    let appleLoginResult: PublishSubject<LoginResult> = PublishSubject()
    
    public func kakaoLogin() {
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.rx.loginWithKakaoTalk()
                .subscribe(onNext: {(oauthToken) in
                    print("kakao Acccount login Success")
                    let result = LoginResult.success(token: oauthToken.accessToken)
                    self.kakaoLoginResult.onNext(result)
                }, onError: { error in
                    print(error)
                })
                .disposed(by: disposeBag)
        } else {
            UserApi.shared.rx.loginWithKakaoAccount()
                .subscribe(onNext: {(oauthToken) in
                    print("kakao Acccount login Success")
                    let result = LoginResult.success(token: oauthToken.accessToken)
                    self.kakaoLoginResult.onNext(result)
                    
                    
                    
                }, onError: { error in
                    print(error)
                })
                .disposed(by: disposeBag)
        }
    }
    
    public func setUserInfo() {
        UserApi.shared.me() { (user,error) in
            if let error = error {
                print(error)
            }
            
            else {
                print("user load success")
                let userDefaults = UserDefaults.standard
                
            }
        }
    }
    
    
    
    func appleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        
        request.requestedScopes = [.fullName,.email]
        
        let authorizationController =
        ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func handleLoginSuccess() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate,
           let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
            sceneDelegate.window?.rootViewController = tabBarController
        }
    }
    
}

extension LoginViewModel: ASAuthorizationControllerDelegate {
    
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

            let token = appleIDCredential.identityToken?.base64EncodedString() ?? ""
            let result = LoginResult.success(token: token)
            appleLoginResult.onNext(result)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {

        let result = LoginResult.failure(error: error)
        appleLoginResult.onNext(result)
    }
}


extension LoginViewModel: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            // Apple 로그인 컨트롤러의 표시 위치를 지정합니다.
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                fatalError("No active UIWindowScene available.")
            }
            return scene.windows.first ?? UIWindow()
        }
}
