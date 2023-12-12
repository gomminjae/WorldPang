//
//  VocaDetailCell.swift
//  WorldPang
//
//  Created by 권민재 on 11/30/23.
//

import UIKit
import SnapKit

class VocaDetailCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .mainWhite
        addSubview(speakerEnButton)
        addSubview(meanButton)
        addSubview(titleLabel)
        
        speakerEnButton.snp.makeConstraints {
            $0.leading.equalTo(self).inset(10)
            $0.top.equalTo(self).inset(10)
            $0.width.height.equalTo(70)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(self).inset(10)
        }
        meanButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel).offset(40)
            $0.centerX.equalTo(self)
            $0.width.equalTo(90)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI
    let titleLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let meanLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
  
    let meanButton: UIButton = {
        let button = UIButton()
        button.setTitle("정답 보기", for: .normal)
        button.backgroundColor = .mainBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
        
    }()
    
    let speakerEnButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        button.tintColor = .mainBlue
        return button
    }()
    
    
    
    
    
    

}
