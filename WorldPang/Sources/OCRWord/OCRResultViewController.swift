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
    
    let parsing = DaumDictionaryService.shared

    

    override func viewDidLoad() {
        super.viewDidLoad()
        parsing.searchDaumDictionary(queryKeyword: "do") { results,a  in
            // Handle the results array here
            print(results,a)
        }

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        
        view.backgroundColor = .white
        
        view.addSubview(originalTextSection)
        view.addSubview(translatedTextSection)
        
        originalTextSection.addSubview(originalTextLabel)
        originalTextSection.addSubview(speakerButton)
        
        
        translatedTextSection.addSubview(translationLabel)
        
        
        
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
        speakerButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.top.leading.equalTo(originalTextSection)
        }
        
        translationLabel.snp.makeConstraints {
            $0.centerY.centerX.equalTo(translatedTextSection)
        }
        
        

    }
    
    override func bindRX() {
        
        viewModel.recognizedText(on: ocrImage)
            .subscribe(onNext: { [weak self] recognizedText in
                self?.originalTextLabel.text = recognizedText
                //self?.viewModel.translation(with: translatedText)
                self?.viewModel.translatedString = recognizedText
                
            })
            .disposed(by: disposeBag)
        
        viewModel.translatedTextSubject
            .bind(to: translationLabel.rx.text)
            .disposed(by: disposeBag)
        
        speakerButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.ttsManager.play(self?.viewModel.translatedString ?? "")
            })
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
        label.text = "Hello"
        label.sizeToFit()
        //label.text = "Heool"
        return label
    }() 
    
    let translationLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요"
        label.sizeToFit()
        return label
    }()
    
    let speakerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "speaker.wave.3.fill"), for: .normal)
        return button
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
