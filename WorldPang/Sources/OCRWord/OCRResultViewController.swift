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
    
    
    var ocrImage = UIImage()
        
    private let disposeBag = DisposeBag()
    private let viewModel = OCRViewModel()
    
    

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        
        view.backgroundColor = .white
        
        view.addSubview(originalTextSection)
        view.addSubview(translatedTextSection)
        
        originalTextSection.addSubview(originalTextLabel)
        
        
    }
    
    override func setupLayout() {
        originalTextSection.snp.makeConstraints {
            $0.leading.trailing.equalTo(view)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(100)
        }
        
        translatedTextSection.snp.makeConstraints {
            $0.top.equalTo(originalTextSection.snp.bottom)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(100)
        }
        
        originalTextLabel.snp.makeConstraints {
            $0.centerX.centerY.equalTo(originalTextSection)
        }
        
        

    }
    
    override func bindRX() {
        
        viewModel.recognizedText(on: ocrImage)
            .bind(to: originalTextLabel.rx.text)
            .disposed(by: disposeBag)

    }
    

    
    //MARK: UI
    
    let originalTextSection: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    let translatedTextSection: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Recognized Text"
        
        return label
    }()
    
    let originalTextLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        //label.text = "Heool"
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
