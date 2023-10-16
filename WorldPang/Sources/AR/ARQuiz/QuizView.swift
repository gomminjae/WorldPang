//
//  QuizView.swift
//  WorldPang
//
//  Created by 권민재 on 2023/10/17.
//
import UIKit
import SnapKit


class QuizView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: UI
    lazy var baseView: UIView = {
        let view = UIView()
        return view
    }()
    
}
