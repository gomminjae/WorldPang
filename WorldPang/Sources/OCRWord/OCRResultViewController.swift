//
//  OCRResultViewController.swift
//  WorldPang
//
//  Created by 권민재 on 2023/11/13.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxDataSources


class OCRResultViewController: BaseViewController {
    
    
    
    private let disposeBag = DisposeBag()
    private let viewModel = OCRViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        
        
    }
    
    override func setupLayout() {
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view)
            $0.leading.trailing.equalTo(view)
            $0.bottom.equalTo(view)
        }
        

    }
    
    override func bindRX() {
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Voca>>(configureCell: { [self]_, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCell.reusableIdentifier, for: indexPath) as? WordCell else { return UICollectionViewCell() }
            
            self.viewModel.recognizedTextSubject
                .subscribe(onNext: { newText in
                    cell.wordLabel.text = newText
                })
                .disposed(by: disposeBag)
            return cell
        },configureSupplementaryView: { (datasource, collectionView, kind, indexPath) -> UICollectionReusableView in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TranslationView.reusableIdentifier, for: indexPath)
                return header
        
        })
        
        
        Observable.of(viewModel.dummyData)
            .map { [SectionModel(model: "", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        
//        translatedWordsTableView.rx.contentOffset
//            .map { $0.y }
//            .bind(to: headerView.rx.stretchableHeader())
//            .disposed(by: disposeBag)
        
        viewModel.recognizedTextSubject
            .subscribe(onNext: { [weak self] text in
                self?.originalTextLabel.text = text
                self?.viewModel.translation(with: text ?? "")
            })
            .disposed(by: disposeBag)
        
        viewModel.translatedTextSubject
            .bind(to: translationLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        
        
    }
    

    
    //MARK: UI
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Recognized Text"
        
        return label
    }()
    
    let originalTextLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }() 
    
    let translationLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 80)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(WordCell.self, forCellWithReuseIdentifier: WordCell.reusableIdentifier)
        cv.register(TranslationView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TranslationView.reusableIdentifier)
        
        return cv
    }()
}

extension OCRResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
           return CGSize(width: collectionView.bounds.width, height: 300)
       }
}
