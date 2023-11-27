//
//  VocaDetailViewController.swift
//  WorldPang
//
//  Created by 권민재 on 11/27/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class VocaDetailViewController: BaseViewController {

    private let viewModel = VocaDetailViewModel()
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.vocaDetailRelay
            .subscribe(onNext: { voca in
                print(voca)
            })
            .disposed(by: disposeBag)

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        
    }
    
    override func setupLayout() {
        
    }
    
    override func bindRX() {
        
    }
    


}
