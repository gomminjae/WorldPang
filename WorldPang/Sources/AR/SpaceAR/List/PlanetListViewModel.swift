//
//  PlanetListViewModel.swift
//  WorldPang
//
//  Created by 권민재 on 2023/11/18.
//

import Foundation
import RxSwift
import RxCocoa
import SceneKit
import ARKit


class PlanetListViewModel {
    
    
    var planetObservable: Observable<[Planet]> {
        return Observable.of(planetList)
    }
    
    let planetList: [Planet] = [
        Planet(key: "sun",title: "Sun(태양)", content: "nil", planetImage: UIImage(named: "sun.png")),
        Planet(key: "mecury",title: "Mecury(수성)", content: "nil", planetImage: UIImage(named: "mercury.png")),
        Planet(key: "venus",title: "Venus(금성)", content: "nil", planetImage: UIImage(named: "venus.png")),
        Planet(key: "earth",title: "Earth(지구)", content: "nil", planetImage: UIImage(named: "earth.png")),
        Planet(key: "moon",title: "Moon(달)", content: "nil", planetImage: UIImage(named: "moon.png"))
    ]
    
}
