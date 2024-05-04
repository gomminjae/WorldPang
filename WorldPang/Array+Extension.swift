//
//  Array+Extension.swift
//  WorldPang
//
//  Created by 권민재 on 5/4/24.
//

import Foundation

extension Array where Element: Comparable {
    func argmax() -> Int? {
        guard let maxElement = self.max() else { return nil }
        return firstIndex(of: maxElement)
    }
}
