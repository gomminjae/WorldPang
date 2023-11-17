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
    
    private let disposeBag = DisposeBag()
    
    var planetObservable: Observable<[Planet]> {
        return Observable.of(planetList)
    }
    
    let planetList: [Planet] = [
        Planet(title: "Sun(태양)", content: "nil", planetImage: UIImage(named: "sun.png")),
        Planet(title: "Mecury(수성)", content: "nil", planetImage: UIImage(named: "mercury.png")),
        Planet(title: "Venus(금성)", content: "nil", planetImage: UIImage(named: "venus.png")),
        Planet(title: "Earth(지구)", content: "nil", planetImage: UIImage(named: "earth.png")),
        Planet(title: "Moon(달)", content: "nil", planetImage: UIImage(named: "moon.png"))
        
    ]
    
}
