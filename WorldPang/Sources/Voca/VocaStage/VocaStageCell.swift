//
//  VocaListCell.swift
//  WorldPang
//
//  Created by 권민재 on 2023/11/22.
//

import UIKit
import SnapKit


class VocaStageCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.layer.borderColor = UIColor.mainBlue.cgColor
        self.layer.borderWidth = 4
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(studyButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self).inset(20)
            $0.leading.equalTo(self).inset(20)
        }
        subTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        studyButton.snp.makeConstraints {
            $0.trailing.equalTo(self).inset(20)
            $0.centerY.equalTo(self)
            $0.width.equalTo(80)
            $0.height.equalTo(40)
        }
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Stage 1"
        label.sizeToFit()
        label.textColor = .gray
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "필수! 초등학교 기본 영단어"
        label.sizeToFit()
        label.textColor = .black
        return label
    }()
    
    let studyButton: UIButton = {
        let button = UIButton()
        button.setTitle("학습하기", for: .normal)
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = 10
        return button
    }()
    
}
