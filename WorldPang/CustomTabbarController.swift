//
//  CustomTabbarController.swift
//  WorldPang
//
//  Created by 권민재 on 2023/09/23.
//

import UIKit
import SnapKit

//class CustomTabbarController: UITabBarController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTabbar()
//
//        // Do any additional setup after loading the view.
//    }
//    
//    private func setupTabbar() {
//        tabBar.backgroundColor = .subIndigo
//        tabBar.tintColor = .mainBackground
//        
//        tabBar.layer.cornerRadius = 15 // whatever you want
//        tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
//    }
//    
//
//}
class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupMiddleButton()
    }

    // TabBarButton – Setup Middle Button
    func setupMiddleButton() {
        let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - 25, y: -20, width: 60, height: 60))
        
        // STYLE THE BUTTON YOUR OWN WAY
        middleBtn.backgroundColor = .red
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
        middleBtn.layer.cornerRadius = (middleBtn.layer.frame.width / 2)
        middleBtn.setImage(UIImage(systemName: "plus.circle", withConfiguration: largeConfig), for: .normal)
        middleBtn.tintColor = .darkGray
        
        // Add to the tab bar and add click event
        let customTabBar = CustomTabbar()
        customTabBar.setupCustomTabBar()
        customTabBar.addSubview(middleBtn)
        middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)
        
        // Set custom tab bar
        self.setValue(customTabBar, forKey: "tabBar")
        self.view.layoutIfNeeded()
    }

    // Menu Button Touch Action
    @objc func menuButtonAction(sender: UIButton) {
        self.selectedIndex = 2   // to select the middle tab. Use "1" if you have only 3 tabs.
        print("MenuButton")
        self.tabBar.backgroundColor = .blue
    }
}

@IBDesignable
class CustomTabbar: UITabBar {
    
    private var shapeLayer: CALayer?
    
    func setupCustomTabBar() {
        self.addShape()
    }
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        
        // The below 4 lines are for the shadow above the bar. You can skip them if you do not want a shadow
        shapeLayer.shadowOffset = CGSize(width: 0, height: 0)
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowColor = UIColor.gray.cgColor
        shapeLayer.shadowOpacity = 0.3
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    func createPath() -> CGPath {
        let height: CGFloat = 40.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        path.move(to: CGPoint(x: 0, y: 0)) // start top left
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0)) // the beginning of the trough
        
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth + 30), y: 0), controlPoint2: CGPoint(x: centerWidth + 35, y: height))
        
        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 35, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
        
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        
        return path.cgPath
    }
}
