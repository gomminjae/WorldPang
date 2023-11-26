//
//  LoginViewModel.swift
//  WorldPang
//
//  Created by 권민재 on 2023/09/22.


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

enum SocialLogin {
    case kakao
    case apple
}

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
    
    let homeViewModel = HomeViewModel()
    
    private var userInfo: User?
    
   
    public func kakaoLogin() {
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.rx.loginWithKakaoTalk()
                .subscribe(onNext: {(oauthToken) in
                    print("kakao Acccount login Success")
                    self.fetchKakaoUserInfo()
                    let result = LoginResult.success(token: oauthToken.accessToken)
                    self.kakaoLoginResult.onNext(result)
                }, onError: { error in
                    print(error)
                })
                .disposed(by: disposeBag)
        } else {
            UserApi.shared.rx.loginWithKakaoAccount()
                .subscribe(onNext: {(oauthToken) in
                    self.fetchKakaoUserInfo()
                    print("kakao Acccount login Success")
                    let result = LoginResult.success(token: oauthToken.accessToken)
                    self.kakaoLoginResult.onNext(result)
                    
                    
                }, onError: { error in
                    print(error)
                })
                .disposed(by: disposeBag)
        }
    }
    
    public func fetchKakaoUserInfo() {
        UserApi.shared.me() { user,error in
            if let error = error {
                print(error)
            } else {
                print("get user succeess")
                if let nickname = user?.kakaoAccount?.profile?.nickname,
                   let profileImage = user?.kakaoAccount?.profile?.profileImageUrl,
                   let email = user?.kakaoAccount?.email {
                    
                    print("\(nickname),,, \(email)")
                    
                    let userInfo = User(nickname: nickname, email: email, profileImageURL: profileImage)
                    self.saveUserData(user: userInfo,loginType: .kakao)
                    self.homeViewModel.userInfo.onNext(userInfo)
                } else {
                    print("Some user information is nil")
                }
                
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
    
    func saveUserData(user: User, loginType: SocialLogin) {
        
        if loginType == .kakao {
            if let userInfo = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(userInfo, forKey: "User")
            }
        }
        else {
            if let userInfo = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(userInfo, forKey: "AppleUser")
            }
        }
    
    }
    
    func loadUserData(loginType: SocialLogin) -> User? {
        
        if loginType == .kakao {
            if let userInfo = UserDefaults.standard.data(forKey: "User"),
               let user = try? JSONDecoder().decode(User.self, from: userInfo) {
                return user
            }
        } else {
            if let userInfo = UserDefaults.standard.data(forKey: "AppleUser"),
               let user = try? JSONDecoder().decode(User.self, from: userInfo) {
                return user
            }
        }
        return nil
    }
    
    
    
    
    
}

extension LoginViewModel: ASAuthorizationControllerDelegate {
    
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

            let token = appleIDCredential.identityToken?.base64EncodedString() ?? ""
            let result = LoginResult.success(token: token)
            appleLoginResult.onNext(result)
            
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
            
            let user = User(nickname: credential.fullName?.givenName ?? "", email: credential.email ?? "")
            
            self.saveUserData(user: user, loginType: .apple)
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
