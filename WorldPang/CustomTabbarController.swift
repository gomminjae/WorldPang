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
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
           // 선택된 뷰컨트롤러의 탭 바 아이템 인덱스 가져오기
           if let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) {
               // 탭 바 아이템의 바탕을 원 모양으로 색상 변경
               customizeTabBarItem(index: selectedIndex)
           }
       }
       
       // 탭 바 아이템 커스터마이징 메서드
       func customizeTabBarItem(index: Int) {
           guard let tabBarItems = tabBar.items else {
               return
           }
           
           // 모든 탭 바 아이템 초기화
           for (i, item) in tabBarItems.enumerated() {
                      item.title = nil
                      item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
               item.image = UIImage(systemName: "circle.fill")?.withTintColor(i == index ? .systemIndigo : .gray, renderingMode: .alwaysOriginal)
                  }
       }
    
}
