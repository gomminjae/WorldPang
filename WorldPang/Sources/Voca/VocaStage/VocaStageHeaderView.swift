//
//  VocaStageHeaderView.swift
//  WorldPang
//
//  Created by 권민재 on 12/11/23.
//

import UIKit



class VocaStageHeaderView: UICollectionReusableView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // 이곳에서 초기화 코드 및 레이아웃 설정을 추가할 수 있습니다.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
    }
}
