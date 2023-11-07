//
//  QuizViewController.swift
//  WorldPang
//
//  Created by 권민재 on 2023/10/30.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class QuizViewController: BaseViewController, UICollectionViewDelegate {
    
    
    var textNodeString: String = "" {
        didSet {
            let alphabetArr = textNodeString.replacingOccurrences(of: " ", with: "").map { String($0) }
            bindableTextNodeString.onNext(alphabetArr)
        }
    }
    var bindableTextNodeString = BehaviorSubject<[String]>(value: [])
    var inputTextObservable = PublishSubject<String>()
    
    private let disposeBag = DisposeBag()
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("QuizVC=====>\(textNodeString)")
        view.backgroundColor = .clear
        

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        view.addSubview(baseView)
        view.backgroundColor = UIColor.init(_colorLiteralRed: 0, green: 0, blue: 0, alpha: 0)
           view.isOpaque = false
        
        baseView.addSubview(titleLabel)
        baseView.addSubview(collectionView)
        //collectionView.dataSource = self
        collectionView.register(QuizCell.self, forCellWithReuseIdentifier: QuizCell.reusableIdentifier)
        
        baseView.addSubview(summitButton)
        summitButton.layer.cornerRadius = 20
        
        view.addSubview(boardTextField)
        
    }
    
    override func setupLayout() {
        
        
        
        baseView.snp.makeConstraints {
            $0.leading.equalTo(view)
            $0.trailing.equalTo(view)
            $0.bottom.equalTo(view)
            $0.height.equalTo(view.frame.height / 3 + 50)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(baseView.snp.top)
            $0.centerX.equalTo(baseView)
        }
        
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalTo(baseView)
            $0.trailing.equalTo(baseView)
            $0.bottom.equalTo(summitButton.snp.top)
        }
        
        summitButton.snp.makeConstraints {
            $0.bottom.equalTo(baseView.snp.bottom).inset(20)
            $0.width.equalTo(100)
            $0.height.equalTo(50)
            $0.centerX.equalTo(baseView)
        }
        
        boardTextField.snp.makeConstraints {
            $0.bottom.equalTo(baseView.snp.top)
            $0.leading.trailing.equalTo(view)
            $0.centerX.equalTo(view)
        }
    }
    
    override func bindRX() {
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        bindableTextNodeString
            .map { arr in
                return arr.shuffled()
            }
            .bind(to: collectionView.rx.items(cellIdentifier: QuizCell.reusableIdentifier, cellType: QuizCell.self)) { _,letter,cell in
                cell.letterLabel.text = letter
                cell.backgroundColor = UIColor.random()
                cell.backgroundColor?.withAlphaComponent(0.2)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .asObservable()
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                
                if let cell = self.collectionView.cellForItem(at: indexPath) as? QuizCell,
                   let selectedText = cell.letterLabel.text {
                    self.boardTextField.text?.append(selectedText)
                    cell.backgroundColor = .lightGray
                    cell.isUserInteractionEnabled = false
                    
                }
            })
            .disposed(by: disposeBag)
        
        summitButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if self?.boardTextField.text == self?.textNodeString.replacingOccurrences(of: " ", with: "") {
                    print("success")
                    self?.dismiss(animated: true)
                }
                else {
                    self?.resetAllCells()
                    print("fail")
                }
            })
            .disposed(by: disposeBag)
       
    }
    
    private func resetAllCells() {
        // 모든 선택된 셀을 초기화
        if let selectedIndexPaths = collectionView.indexPathsForSelectedItems {
            print(selectedIndexPaths)
            for indexPath in selectedIndexPaths {
                if let cell = collectionView.cellForItem(at: indexPath) as? QuizCell {
                    cell.backgroundColor = UIColor.random()
                    cell.isUserInteractionEnabled = true
                    boardTextField.text = ""
                    collectionView.deselectItem(at: indexPath, animated: false)
                }
            }
            
        }
    }
    //MARK: UI
    lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "문제를 풀어보아요!"
        label.textColor = .black
        return label
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        return view
    }()
    
    lazy var summitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .subYellow
        button.setTitle("제출", for: .normal)
        return button
    }()
    
    lazy var boardTextField: UITextField = {
        let tf = UITextField()
        tf.textColor = .systemGreen
        tf.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        tf.textAlignment = .center
        tf.placeholder = "정답을 써주세요!"
        return tf
    }() 
    
    
}

//MARK: Cell Test
//extension QuizViewController: UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 8
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuizCell.reusableIdentifier, for: indexPath) as? QuizCell else { return UICollectionViewCell()}
//        
//        cell.letterLabel.text = "Q"
//        cell.backgroundColor = UIColor.random()
//        return cell
//    }
//    
//    
//}
