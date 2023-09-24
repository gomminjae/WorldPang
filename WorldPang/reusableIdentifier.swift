//
//  reusableIdentifier.swift
//  WorldPang
//
//  Created by 권민재 on 2023/09/24.
//

import Foundation


extension NSObject {
    
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}
