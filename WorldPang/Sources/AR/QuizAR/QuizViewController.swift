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

class QuizViewController: BaseViewController {
    
    private let quizViewModel = QuizViewModel()
    private let disposeBag = DisposeBag()
    
    
    

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
            $0.leading.trailing.top.bottom.equalTo(self.view)
        }
    }
    
    override func bindRX() {
        quizViewModel.alphabetObservable
            .map { $0.shuffled() }
            .bind(to: collectionView.rx.items(cellIdentifier: QuizCell.reusableIdentifier)) { _,letter,cell in
                if let cell = cell as? QuizCell {
                    cell.letterLabel.text = letter
                    cell.backgroundColor = UIColor.random()
                }
            }
            .disposed(by: disposeBag)
                
                                                                                               
                                                                                
    }
    
    
    
    
    
    //MARK: UI
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        view.register(QuizCell.self, forCellWithReuseIdentifier: QuizCell.reusableIdentifier)
        return view
    }()
    
    


}
