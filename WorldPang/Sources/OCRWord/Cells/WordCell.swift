//
//  WordCell.swift
//  WorldPang
//
//  Created by 권민재 on 2023/11/14.
//

import UIKit
import SnapKit

class WordCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        addSubview(wordLabel)
        addSubview(meanLabel)
        
        wordLabel.snp.makeConstraints {
            $0.leading.equalTo(self).inset(20)
            
        }
        meanLabel.snp.makeConstraints {
            $0.leading.equalTo(wordLabel.snp.leading)
            $0.top.equalTo(wordLabel.snp.bottom).offset(6)
        }
    }
    
    //MARK: UI
    
    let wordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    let meanLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    
}
