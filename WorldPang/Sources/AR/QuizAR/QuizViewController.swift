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
        
        baseView.addSubview(titleLabel)
        baseView.addSubview(collectionView)
        //collectionView.dataSource = self
        collectionView.register(QuizCell.self, forCellWithReuseIdentifier: QuizCell.reusableIdentifier)
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
            $0.bottom.equalTo(baseView)
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
            .subscribe(onNext: { [weak self] indexPath in
                if let cell = self?.collectionView.cellForItem(at: indexPath) as? QuizCell {
                    if let text = cell.letterLabel.text {
                        self?.inputTextObservable
                            .scan("") { acc,newValue in
                                return acc + newValue
                            }
                            .subscribe(onNext: { acc in
                                print("=====>Text: \(acc)")
                            })
                            .dispose()
                    }
                }
            })
            .disposed(by: disposeBag)
       
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
        return button
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
