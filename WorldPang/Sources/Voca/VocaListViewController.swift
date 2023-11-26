//
//  VocaTestViewController.swift
//  WorldPang
//
//  Created by 권민재 on 2023/10/16.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit


class VocaListViewController: BaseViewController {
    
    //private let viewModel = VocaListViewModel()
    private let disposeBag = DisposeBag()
    private let viewModel = VocaListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        view.addSubview(collectionView)
    }
    
    override func setupLayout() {
        collectionView.snp.makeConstraints {
            $0.leading.equalTo(view)
            $0.trailing.equalTo(view)
            $0.bottom.equalTo(view)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func bindRX() {
        
        
    
        
       
    }
    
    
    //MARK: UI
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(VocaStageCell.self, forCellWithReuseIdentifier: VocaStageCell.reusableIdentifier)
        return view
    }()
    
    
}
