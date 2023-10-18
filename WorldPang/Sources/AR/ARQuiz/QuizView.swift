//
//  QuizView.swift
//  WorldPang
//
//  Created by 권민재 on 2023/10/17.
//
import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol QuizViewDelegate {
    var simmitSubject: PublishSubject<String> { get }
}


class QuizView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(baseView)
        baseView.addSubview(summitButton)
    }
    
    
    //MARK: UI
    lazy var baseView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var summitButton: UIButton = {
        let button = UIButton()
        button.setTitle("제풀", for: .normal)
        return button
    }()
    
    lazy var alphabetCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }() 
    
    
}
