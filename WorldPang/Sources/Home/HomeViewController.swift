//
//  HomeViewController.swift
//  WorldPang
//
//  Created by 권민재 on 2023/09/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class HomeViewController: BaseViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        view.addSubview(titleLabel)
        
        view.addSubview(cloudImage)
        
        view.addSubview(baseView)
        baseView.addSubview(userCurrentStateView)
        
        view.addSubview(pagerCollectionView)
        
        userCurrentStateView.addSubview(middleSideBar)
        
        
    }
    
    override func setupLayout() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.leading.equalTo(view).inset(30)
        }
        cloudImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.trailing.equalTo(view)
            $0.height.equalTo(120)
        }
        
        
        baseView.snp.makeConstraints {
            $0.leading.equalTo(view)
            $0.trailing.equalTo(view)
            $0.top.equalTo(titleLabel.snp.bottom).offset(80)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        userCurrentStateView.snp.makeConstraints {
            $0.leading.equalTo(baseView).inset(20)
            $0.trailing.equalTo(baseView).inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.height.equalTo(90)
        }
        
        pagerCollectionView.snp.makeConstraints {
            $0.top.equalTo(userCurrentStateView.snp.bottom).offset(10)
            $0.leading.equalTo(view)
            $0.trailing.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        
        middleSideBar.snp.makeConstraints {
            $0.top.equalTo(userCurrentStateView.snp.top).inset(20)
            $0.bottom.equalTo(userCurrentStateView.snp.bottom).inset(20)
            $0.width.equalTo(2)
            $0.centerX.equalTo(userCurrentStateView)
        }
    }
    
    override func bindRX() {
        
    }
    
    //MARK: UI
    
    
    lazy var pagerCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var cloudImage: UIImageView = {
        let view = UIImageView()
        //view.backgroundColor = .red
        view.image = UIImage(named: "cloud.png")
        return view
    }()
    
    lazy var middleSideBar: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    
    
    
    lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBackground
        view.layer.cornerRadius = 40
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    lazy var userCurrentStateView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBackground
        view.layer.borderWidth = 0.1
        view.layer.cornerRadius = 20
        view.setShadow()
        return view
    }()
    
    
   
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Let's Play"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 35, weight: .heavy)
        return label
    }()
    
    
    
    
    
    
    

}
