//
//  CustomTabbarController.swift
//  WorldPang
//
//  Created by 권민재 on 2023/09/23.
//

import UIKit
import SnapKit

class CustomTabbarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()

        // Do any additional setup after loading the view.
    }
    
    private func setupTabbar() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .mainBlue
        
        tabBar.layer.cornerRadius = 15 // whatever you want
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        if let tabBar = self.tabBarController?.tabBar {
            tabBar.barTintColor = UIColor.white
        }
    }
    

    
}
