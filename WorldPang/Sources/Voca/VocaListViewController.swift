//
//  VocaTestViewController.swift
//  WorldPang
//
//  Created by 권민재 on 2023/10/16.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import AVFoundation


class VocaListViewController: BaseViewController {
    
    //private let viewModel = VocaListViewModel()
    private let disposeBag = DisposeBag()
    

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
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.setTitle("카메라", for: .normal)
        return button
    }()
    
    lazy var albumButton: UIButton = {
        let button = UIButton()
        button.setTitle("앨범", for: .normal)
        return button
    }()
}
