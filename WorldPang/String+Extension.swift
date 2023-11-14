//
//  String+Extension.swift
//  WorldPang
//
//  Created by 권민재 on 2023/11/14.
//

import Foundation


extension String {
    
    func removeNewLines() -> String {
        return self.replacingOccurrences(of: "\n", with: " ")
    }
}
