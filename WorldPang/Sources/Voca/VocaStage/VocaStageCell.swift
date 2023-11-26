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
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self).inset(20)
            $0.leading.equalTo(self).inset(20)
        }
        subTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
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
}
