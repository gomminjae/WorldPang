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

class TranslationView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(englishLabel)
        addSubview(originalTextLabel)
        addSubview(speakerEnButton)
        
        
        addSubview(speakerKrButton)
        addSubview(koreanLabel)
        addSubview(translatedTextLabel)
        
        speakerEnButton.snp.makeConstraints {
            $0.top.equalTo(self).inset(10)
            $0.leading.equalTo(self).inset(5)
            $0.width.height.equalTo(40)
        }
        
        englishLabel.snp.makeConstraints {
            $0.leading.equalTo(speakerKrButton.snp.trailing).offset(8)
            $0.top.bottom.equalTo(speakerEnButton)
        }
        
        originalTextLabel.snp.makeConstraints {
            $0.top.equalTo(speakerEnButton.snp.bottom)
            $0.leading.equalTo(speakerEnButton.snp.leading).offset(10)
            
        }
        
        speakerKrButton.snp.makeConstraints {
            $0.leading.equalTo(speakerEnButton)
            $0.top.equalTo(originalTextLabel.snp.bottom).offset(40)
            $0.width.height.equalTo(40)
        }
        koreanLabel.snp.makeConstraints {
            $0.leading.equalTo(speakerEnButton.snp.trailing).offset(8)
            $0.top.bottom.equalTo(speakerKrButton)
        }
        translatedTextLabel.snp.makeConstraints {
            $0.top.equalTo(speakerKrButton.snp.bottom)
            $0.leading.equalTo(speakerKrButton.snp.leading).offset(10)
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
        label.text = "ㅇㅁㄴㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㄴㄹㅁㅇ"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.sizeToFit()
        return label
    }()
    let translatedTextLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.text = "sdㄹㅁㄴㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹ"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let speakerEnButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        button.tintColor = .mainBlue
        return button
    }()
    let speakerKrButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        button.tintColor = .mainBlue
        return button
    }()
    
}
