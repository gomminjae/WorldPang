//
//  BaseViewController.swift
//  WorldPang
//
//  Created by 권민재 on 2023/09/23.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradient(color1: .mainYellow, color2: .subYellow)
        setupView()
        setupLayout()
        bindRX()

        // Do any additional setup after loading the view.
    }
    
    
    func setupView(){}
    func setupLayout(){}
    func bindRX() {}
}
