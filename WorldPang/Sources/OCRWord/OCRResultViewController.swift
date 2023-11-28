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
    private let ttsManager = TTSManager()
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let arr = ["danger", "do", "not", "enter"]
//        let dispatchGroup = DispatchGroup()
//
//        for word in arr {
//            dispatchGroup.enter()
//
//            DaumDictionaryService.shared.searchDaumDictionary(queryKeyword: word) { result, means in
//                // 여기에서 결과를 처리하거나 저장
//                print(result, means)
//
//                // 해당 비동기 작업이 완료되었음을 DispatchGroup에 알림
//                dispatchGroup.leave()
//            }
//        }
        

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        
        view.backgroundColor = .mainWhite
        view.addSubview(baseView)
        baseView.layer.cornerRadius = 20
        
        view.addSubview(collectionView)

        
        
    }
    
    override func setupLayout() {
        
        baseView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view).inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(200)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(baseView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view).inset(20)
            $0.bottom.equalTo(view).inset(20)
        }
        

        

    }
    
    
    override func bindRX() {
        
        
        viewModel.recognizedText(on: ocrImage)
            .subscribe(onNext: { [weak self] recognizedText in
                self?.viewModel.recognizedString = recognizedText
                self?.baseView.originalTextLabel.text = recognizedText
                self?.viewModel.translation(with: recognizedText)
                self?.viewModel.ttsString = recognizedText
                self?.viewModel.getParseVocaList(with: recognizedText)
            })
            .disposed(by: disposeBag)
        
        viewModel.translatedTextSubject
            .bind(to: baseView.translatedTextLabel.rx.text)
            .disposed(by: disposeBag)
        
        baseView.speakerEnButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.ttsManager.play(self?.viewModel.ttsString ?? "")
            })
            .disposed(by: disposeBag)
        
        
        viewModel.getRelatedWords(viewModel.recognizedString)
            .bind(to: collectionView.rx.items(cellIdentifier: WordCell.reusableIdentifier, cellType: WordCell.self)) { _,word,cell in
                cell.wordLabel.text = word
            }
            .disposed(by: disposeBag)

    }
    

    
    //MARK: UI
    let baseView = TranslationView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(WordCell.self, forCellWithReuseIdentifier: WordCell.reusableIdentifier)
        cv.backgroundColor = .white
        cv.layer.cornerRadius = 20
        return cv
    }()
}

