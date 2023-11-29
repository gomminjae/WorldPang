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


class VocaStageHeaderView: UICollectionReusableView {
    
    // 헤더 뷰의 타이틀을 표시하는 레이블
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        // 필요한 스타일 및 속성을 여기에 추가하세요.
        return label
    }()
    
    // 이곳에서 초기화 코드 및 레이아웃 설정을 추가할 수 있습니다.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
    }
}

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
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(VocaStageCell.self, forCellWithReuseIdentifier: VocaStageCell.reusableIdentifier)
        view.register(VocaStageHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: VocaStageHeaderView.reusableIdentifier)
        view.backgroundColor = .mainWhite
        return view
    }()
    
    
}
