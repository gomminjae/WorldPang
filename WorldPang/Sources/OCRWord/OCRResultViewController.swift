//
//  OCRResultViewController.swift
//  WorldPang
//
//  Created by 권민재 on 2023/11/13.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit


class OCRResultViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = OCRViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        
    }
    
    override func setupLayout() {
        
    }
    
    override func bindRX() {
        
    }
    
    //MARK: UI
    
    let translationLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }()
    
    

    

}
