//
//  PlanetListCell.swift
//  WorldPang
//
//  Created by 권민재 on 2023/11/18.
//

import UIKit
import SceneKit
import SnapKit

class PlanetListCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        addSubview(planetImageView)
        addSubview(titleLabel)
        addSubview(contentLabel)
        
        planetImageView.snp.makeConstraints {
            $0.leading.equalTo(self).inset(10)
            $0.width.height.equalTo(100)
            $0.centerY.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.leading.equalTo(planetImageView.snp.trailing).offset(20)
        }
        
    
    }
    
    
    //MARK: UI
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var planetImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()

}
