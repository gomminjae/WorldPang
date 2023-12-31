//
//  LoginViewController.swift
//  WorldPang
//
//  Created by 권민재 on 2023/09/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainWhite
        
    
    }
    
    
    override func setupView() {
        //view.setGradient(color1: .mainYellow, color2: .subYellow)
        view.addSubview(titleLabel)
        view.addSubview(loginBaseView)
        loginBaseView.addSubview(blurEffectView)
        
        loginBaseView.addSubview(appleLoginButton)
        loginBaseView.addSubview(kakaoLoginButton)
        
        loginBaseView.addSubview(centerLineLabel)
    }
    
    override func setupLayout() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(55)
            $0.leading.trailing.equalTo(view).inset(20)
        }
        
        loginBaseView.snp.makeConstraints {
            $0.leading.equalTo(view).inset(20)
            $0.trailing.equalTo(view).inset(20)
            $0.centerY.equalTo(view)
            $0.height.equalTo(240)
        }
        
        
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(loginBaseView.snp.top).inset(20)
            $0.leading.equalTo(loginBaseView.snp.leading).inset(10)
            $0.trailing.equalTo(loginBaseView.snp.trailing).inset(10)
            $0.height.equalTo(70)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(loginBaseView.snp.bottom).inset(20)
            $0.leading.equalTo(appleLoginButton.snp.leading)
            $0.trailing.equalTo(appleLoginButton.snp.trailing)
            $0.height.equalTo(70)
        }
        
        centerLineLabel.snp.makeConstraints {
            $0.top.equalTo(appleLoginButton.snp.bottom)
            $0.bottom.equalTo(kakaoLoginButton.snp.top)
            $0.leading.equalTo(appleLoginButton.snp.leading)
            $0.trailing.equalTo(appleLoginButton.snp.trailing)
        }
    }
    
    override func bindRX() {
        kakaoLoginButton.button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.kakaoLogin()
            })
            .disposed(by: disposeBag)
        
        
        appleLoginButton.button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.appleLogin()
            })
            .disposed(by: disposeBag)
        
        
        viewModel.kakaoLoginResult
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(_):
                    print("kakao Login Success")
                    self?.viewModel.handleLoginSuccess()
                    //self?.setupInitialVC()
                case .failure(_):
                    print("kakao Login fail")
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.appleLoginResult
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(_):
                    print("apple login success")
                    self?.viewModel.handleLoginSuccess()
                case .failure(_):
                    print("apple login fail")
                }
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: UI
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "WorldPang"
        label.textColor = .mainBlue
        label.font = UIFont.boldSystemFont(ofSize: 59)
        label.textAlignment = .center
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var loginBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        view.layer.cornerRadius = 30
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.frame = self.loginBaseView.bounds
        return view
    }()
    
    
    lazy var appleLoginButton: LoginButton = {
        let button = LoginButton()
        button.titleLabel.text = "Sign With Apple"
        button.imageView.image = UIImage(named: "applelogin.png")
        button.layer.borderWidth = 0.5
        return button
    }()
    
    lazy var kakaoLoginButton: LoginButton = {
        let button = LoginButton()
        button.titleLabel.text = "Sign With Kakao"
        button.imageView.image = UIImage(named: "kakaologin.png")
        button.layer.borderWidth = 0.9
        return button
    }()
    
    lazy var centerLineLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "OR"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        return label
    }()
    

}
