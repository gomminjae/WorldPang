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
import RxDataSources


class VocaStageViewController: BaseViewController {

    private let disposeBag = DisposeBag()
    private let viewModel = VocaStageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
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
                let vc = VocaDetailViewController(selectedIndex: indexPath.row)
                self.navigationController?.pushViewController(vc, animated: true)
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
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(VocaStageCell.self, forCellWithReuseIdentifier: VocaStageCell.reusableIdentifier)
        view.register(VocaStageHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: VocaStageHeaderView.reusableIdentifier)
        view.backgroundColor = .mainWhite
        return view
    }()
    
    
}
