//
//  PagerCell.swift
//  WorldPang
//
//  Created by 권민재 on 2023/09/24.


import UIKit
import SnapKit

class PagerCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 20
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        addSubview(imageView)
        addSubview(titleLabel)
        
        imageView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(self)
        }
        
        
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self).inset(20)
            $0.leading.equalTo(self).inset(20)
            $0.trailing.equalTo(self).inset(20)
            $0.width.equalTo(self.frame.width * 0.7)
        }
    }
    
    
    //MARK: UI
    lazy var baseView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = view.frame.width / 2
        view.clipsToBounds = true
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "물건을 촬영하여 영아단어를 학습하세요!"
        label.font = UIFont.systemFont(ofSize: 20,weight: .bold)
        label.textColor = .black
        label.sizeToFit()
        label.numberOfLines = 2
        return label
    }()
    
    
    
    
    
}
