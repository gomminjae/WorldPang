//
//  ParticleViewController.swift
//  WorldPang
//
//  Created by 권민재 on 2023/10/11.
//

import UIKit
import ARKit


enum Particles: String {
    case smoke
    case fire
    case stars
    case rain
    
    static var order: [Particles] = [
        .smoke,
        .fire,
        .stars,
    ]
}


class ParticleViewController: UIViewController {
    


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func addParticle(_ particle: Particles) {
    
    }

}
extension ParticleViewController: ARSKViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
           
    }
}
