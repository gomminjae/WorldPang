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


class VocaStageViewController: BaseViewController {
    
    //private let viewModel = VocaListViewModel()
    private let disposeBag = DisposeBag()
    private let viewModel = VocaStageViewModel()
    
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
        
        viewModel.listHomeSection
            .bind(to: collectionView.rx.items(cellIdentifier: VocaStageCell.reusableIdentifier, cellType: VocaStageCell.self)) { row,item,cell in
                cell.backgroundColor = .mainWhite
                cell.titleLabel.text = "Stage \(row+1)"
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: {  indexPath in
                self.viewModel.loadwords(index: indexPath.item)
                self.navigationController?.pushViewController(VocaDetailViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    
    //MARK: UI
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width-20, height: 100)
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(VocaStageCell.self, forCellWithReuseIdentifier: VocaStageCell.reusableIdentifier)
        view.backgroundColor = .blue
        return view
    }()
    
    
}
