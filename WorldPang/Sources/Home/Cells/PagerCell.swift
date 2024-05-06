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
        self.backgroundColor = .mainWhite
        self.setShadow()
        setupCell()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        addSubview(imageView)
        addSubview(titleLabel)
        
        imageView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(self)
            $0.bottom.equalTo(titleLabel.snp.top)
        }
        
        
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(self).inset(10)
            $0.centerX.equalTo(self)
            $0.leading.equalTo(self).inset(20)
            $0.trailing.equalTo(self).inset(20)
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
        label.font = UIFont.systemFont(ofSize: 20,weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.sizeToFit()
        label.numberOfLines = 2
        return label
    }()
}
