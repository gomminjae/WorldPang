//
//  LoginButton.swift
//  WorldPang
//
//  Created by 권민재 on 2023/09/24.
//

import UIKit
import SnapKit


class LoginButton: UIView  {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(blurEffectView)
        self.addSubview(button)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        self.layer.cornerRadius = 30
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        addSubview(imageView)
        addSubview(titleLabel)
        
        
        imageView.snp.makeConstraints {
            $0.leading.equalTo(self).inset(5)
            $0.width.height.equalTo(60)
            $0.centerY.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(40)
            $0.trailing.equalTo(self.snp.trailing).inset(15)
            $0.centerY.equalTo(self)
        }
        button.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(self)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    lazy var imageView = UIImageView()
    
    
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.frame = self.bounds
        return view
    }()
    
    lazy var button: UIButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        return view 
    }()
}
