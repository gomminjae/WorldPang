//
//  SpaceViewController.swift
//  WorldPang
//
//  Created by 권민재 on 2023/11/04.
//

import UIKit
import RxSwift
import RxCocoa
import ARKit
import SceneKit


class SpaceViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
        sceneView.automaticallyUpdatesLighting = true
        sceneView.scene.background.contents = UIImage(named: "art.scnassets/background.jpeg")
        
        addSun()
        addMercury()
        addVenus()
        addEarthSystem()
        addMars()
        
        // Do any additional setup after loading the view.
    }
    
    func addSun() {
        let sun = SCNSphere(radius: 0.325)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/sun.jpeg")
        sun.materials = [material]
        
        let nodeSun = SCNNode()
        nodeSun.position = SCNVector3(0, 0, -1)
        nodeSun.geometry = sun
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
        
        parentNode.addChildNode(nodeMars)
        
    }
    
    
    
    //MARK: UI
    
    
  
}


