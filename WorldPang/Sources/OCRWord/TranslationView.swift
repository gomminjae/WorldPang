//
//  TranslationView.swift
//  WorldPang
//
//  Created by 권민재 on 2023/11/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


extension Reactive where Base: UIView {
    func stretchableHeader() -> Binder<CGFloat> {
        return Binder(self.base) { view, offset in
            view.frame.size.height = max(200 - offset,100)
        }
    }
}


class TranslationView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(englishLabel)
        addSubview(originalTextLabel)
        addSubview(speakerButton)
        
        englishLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(self).inset(15)
        }
        originalTextLabel.snp.makeConstraints {
            $0.top.equalTo(englishLabel.snp.bottom).offset(19)
            $0.leading.equalTo(englishLabel)
            $0.trailing.equalTo(self.snp.trailing).inset(15)
        }
        
        speakerButton.snp.makeConstraints {
            $0.top.equalTo(originalTextLabel.snp.bottom).offset(10)
            $0.leading.equalTo(englishLabel)
            $0.width.height.equalTo(70)
        }
        
        addSubview(koreanLabel)
        addSubview(translatedTextLabel)
        
        koreanLabel.snp.makeConstraints {
            $0.leading.equalTo(englishLabel)
            $0.top.equalTo(speakerButton.snp.bottom).offset(20)
        }
        translatedTextLabel.snp.makeConstraints {
            $0.top.equalTo(koreanLabel.snp.bottom)
            $0.leading.equalTo(koreanLabel)
            $0.trailing.equalTo(originalTextLabel.snp.trailing)
        }
    }
    
    
    
    //MARK: UI
    let englishLabel: UILabel = {
        let label = UILabel()
        label.text = "English"
        return label
    }()
    let koreanLabel: UILabel = {
        let label = UILabel()
        label.text = "Korean"
        return label
    }()
    
    let originalTextLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }()
    let translatedTextLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }()
    
    let speakerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "speaker.wave.2"), for: .normal)
        return button
    }()
    
}
