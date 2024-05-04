//
//  QuizCell.swift
//  WorldPang
//
//  Created by 권민재 on 2023/10/30.
//

import UIKit
import SnapKit


class QuizCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(letterLabel)
        self.layer.cornerRadius = 15
        self.backgroundColor = .red
        
        letterLabel.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.centerY.equalTo(self)
        }
        
    }
    let letterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.layer.cornerRadius = 15
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
}
