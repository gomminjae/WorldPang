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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        addSubview(imageView)
    }
    
    
    //MARK: UI
    lazy var baseView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
}
