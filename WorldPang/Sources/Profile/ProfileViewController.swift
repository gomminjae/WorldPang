//
//  ProfileViewController.swift
//  WorldPang
//
//  Created by 권민재 on 2023/09/29.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ProfileViewController: BaseViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        view.backgroundColor = .mainYellow
    }
    
    override func setupLayout() {
        
    }
    
    override func bindRX() {
        
    }
    
    
    
    
    //MARK: UI
    lazy var baseView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var settingCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    

}
