//
//  PointManager.swift
//  WorldPang
//
//  Created by 권민재 on 12/13/23.
//

import Foundation

class PointManager {
    
    static let shared = PointManager()
    private let userDefaults = UserDefaults.standard
    private let pointsKey = "userPoints"
    
    init() {}
    
    func getPoints() -> Int {
        return userDefaults.integer(forKey: pointsKey)
    }
    
    func updatePoints(by amount: Int) {
        let currentPoints = userDefaults.integer(forKey: pointsKey)
        let newPoints = currentPoints + amount
        userDefaults.set(newPoints, forKey: pointsKey)
        userDefaults.synchronize()  // 실제로 저장하기 위해 synchronize 호출 (iOS 13 이전의 버전에서는 필요)
        print("Updated points: \(newPoints)")
    }

}
