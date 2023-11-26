//
//  SpaceViewController.swift
//  WorldPang
//
//  Created by 권민재 on 2023/11/04.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import ARKit
import SceneKit
import SnapKit


class SpaceViewController: BaseViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    
    private let disposeBag = DisposeBag()
    
    
    let nodeTapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal,.vertical]
        
        sceneView.session.run(configuration)
        sceneView.automaticallyUpdatesLighting = true
        sceneView.scene.background.contents = UIImage(named: "art.scnassets/background.jpeg")
        sceneView.addGestureRecognizer(nodeTapGesture)
    
        
        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        addSun()
        addMercury()
        addVenus()
        addEarthSystem()
        addMars()
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(showPlanetListButton)
        stackView.addArrangedSubview(dismissButton)
        
        
    }
    
    override func setupLayout() {
        
        
        stackView.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.width.equalTo(200)
            $0.bottom.equalTo(view.snp.bottom).inset(40)
            $0.height.equalTo(90)
        }
        
        
        
        
    }

    override func bindRX() {
        
        nodeTapGesture.rx
            .event
            .subscribe(onNext: { [weak self] gesture in
                guard let self = self else { return }
                
                let location = gesture.location(in: self.sceneView)
                let hitResult = self.sceneView.hitTest(location, options: nil)
                
                guard let hitedNode = hitResult.first?.node else { return }
                
                
                if let textGeometry = hitedNode.geometry {
                    let nodeName = textGeometry.value(forKey: "planet")
                    print(nodeName)
                }
                self.animateNodeAndPresentView(node: hitedNode)
            })
            .disposed(by: disposeBag)
        
        showPlanetListButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let vc = PlanetListViewController()
                self?.present(vc,animated: true)
            })
            .disposed(by: disposeBag)
        
        dismissButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    func addSun() {
        let sun = SCNSphere(radius: 0.325)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/sun.jpeg")
        sun.materials = [material]
        
        let nodeSun = SCNNode()
        nodeSun.position = SCNVector3(0, 0, -1)
        nodeSun.geometry = sun
        nodeSun.geometry?.setValue("sun", forKey: "planet")
        sceneView.scene.rootNode.addChildNode(nodeSun)
        
    }
    
    func addMercury() {
        
        let parentNode = SCNNode()
        parentNode.position = SCNVector3(0,0,-1)
        sceneView.scene.rootNode.addChildNode(parentNode)
        
        let parentRotation = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 15)
        let parentRotationRepeat = SCNAction.repeatForever(parentRotation)
        parentNode.runAction(parentRotationRepeat)
        
        let mercury = SCNSphere(radius: 0.126)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/mercury.jpeg")
        mercury.materials = [material]
        
        let nodeMercury = SCNNode()
        nodeMercury.position = SCNVector3(x: 0.5, y: 0, z: 0)
        nodeMercury.geometry = mercury
        nodeMercury.geometry?.setValue("mercury", forKey: "planet")
        
        parentNode.addChildNode(nodeMercury)
        
    }
    
    func addVenus() {
        let parentNode = SCNNode()
        parentNode.position = SCNVector3(0,0,-1)
        sceneView.scene.rootNode.addChildNode(parentNode)
        
        let parentRotation = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 18)
        let parentRotationRepeat = SCNAction.repeatForever(parentRotation)
        parentNode.runAction(parentRotationRepeat)
        
        let venus = SCNSphere(radius: 0.130)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/venus.jpeg")
        venus.materials = [material]
        
        let nodeVenus = SCNNode()
        nodeVenus.position = SCNVector3(x: 1, y: 0, z: 0)
        nodeVenus.geometry = venus
        nodeVenus.setValue("venus", forKey: "planet")
        
        parentNode.addChildNode(nodeVenus)
        
        
        
    }
    
    func addEarthSystem() {
        let earthParentNode = SCNNode()
        earthParentNode.position = SCNVector3(0, 0, -1)
        sceneView.scene.rootNode.addChildNode(earthParentNode)
        
        let parentRotaion = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 24)
        let parentRotationRepeat = SCNAction.repeatForever(parentRotaion)
        earthParentNode.runAction(parentRotationRepeat)
        
        let earth = SCNSphere(radius: 0.12)
        let earthMaterial = SCNMaterial()
        earthMaterial.diffuse.contents = UIImage(named: "art.scnassets/earth.jpeg")
        earth.materials = [earthMaterial]
        
        let nodeEarth = SCNNode()
        nodeEarth.position = SCNVector3(1.5, 0, 0)
        nodeEarth.geometry = earth
        nodeEarth.geometry?.setValue("earth", forKey: "planet")
        let earthRotaion = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 8)
        let earthRotaionRepeat = SCNAction.repeatForever(earthRotaion)
        nodeEarth.runAction(earthRotaionRepeat)
        earthParentNode.addChildNode(nodeEarth)
        
        let moonParentNode = SCNNode()
        moonParentNode.position = SCNVector3(2, 0, 0)
        let moonParentRotaion = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 5)
        let moonParentRotationRepeat = SCNAction.repeatForever(moonParentRotaion)
        moonParentNode.runAction(moonParentRotationRepeat)
        
        let moon = SCNSphere(radius: 0.05)
        let moonMaterial = SCNMaterial()
        moonMaterial.diffuse.contents = UIImage(named: "art.scnassets/moon.jpeg")
        moon.materials = [moonMaterial]
        
        let nodeMoon = SCNNode()
        nodeMoon.position = SCNVector3(0, 0, -0.3)
        nodeMoon.geometry = moon
        nodeMoon.geometry?.setValue("moon", forKey: "planet")
        let moonRotaion = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 8)
        let moonRotaionRepeat = SCNAction.repeatForever(moonRotaion)
        nodeMoon.runAction(moonRotaionRepeat)
        moonParentNode.addChildNode(nodeMoon)
        earthParentNode.addChildNode(moonParentNode)
    }
    
    
    func addMars() {
        
        let parentNode = SCNNode()
        parentNode.position = SCNVector3(0,0,-1)
        sceneView.scene.rootNode.addChildNode(parentNode)
        
        let parentRotation = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 15)
        let parentRotationRepeat = SCNAction.repeatForever(parentRotation)
        parentNode.runAction(parentRotationRepeat)
        
        let mars = SCNSphere(radius: 0.126)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/mars.jpeg")
        mars.materials = [material]
        
        let nodeMars = SCNNode()
        nodeMars.position = SCNVector3(x: 2, y: 0, z: 0)
        nodeMars.geometry = mars
        nodeMars.geometry?.setValue("Mars", forKey: "planet")
        
        parentNode.addChildNode(nodeMars)
        
    }
    
    private func animateNodeAndPresentView(node: SCNNode) {
        guard let pointOfView = sceneView.pointOfView else { return }

        // Find the intersection between the screen center and the AR scene
        let screenCenter = CGPoint(x: sceneView.bounds.midX, y: sceneView.bounds.midY)
        let hitTestResults = sceneView.hitTest(screenCenter, options: nil)

        if let hitResult = hitTestResults.first {
            // Get the world coordinates from the SCNHitTestResult
            let destinationPosition = hitResult.worldCoordinates

            // Save the original position
            let originalPosition = node.position

            // Move the node to the intersection point
            let moveAction = SCNAction.move(to: destinationPosition, duration: 1.0)

            // Rotate the node
            let rotateAction = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 1.0)

            // Group actions to run simultaneously
            let groupAction = SCNAction.group([moveAction, rotateAction])

            // Run the group action
            node.runAction(groupAction) {
                // After animation completes, present a new view
                self.presentNewView(for: node)

                // Return the node to its original position
                let returnAction = SCNAction.move(to: originalPosition, duration: 1.0)
                node.runAction(returnAction)
            }
        }
    }
    private func presentNewView(for node: SCNNode) {
        DispatchQueue.main.async {
            let newViewController = PlanetCardViewController()
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    
    
    
    //MARK: UI`
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillProportionally
        view.spacing = 5
        view.axis = .horizontal
        view.backgroundColor?.withAlphaComponent(0.7)
        return view
    }()
    
    
    let showPlanetListButton: UIButton = {
        let button = UIButton()
        button.setTitle("행성 목록 보기", for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .mainBlue
        return button
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("나가기", for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .mainBlue
        return button
    }()
    
    
  
}


