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
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(self).inset(10)
            $0.leading.equalTo(self).inset(20)
            $0.trailing.equalTo(self).inset(20)
            $0.bottom.equalTo(self).inset(20)
        }
    }
    
    
    //MARK: UI
    lazy var baseView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        //view.image = UIImage(named: "ar.png")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    
    
    
    
}
