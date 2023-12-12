//
//  User.swift
//  WorldPang
//
//  Created by 권민재 on 2023/09/29.
//

import Foundation


struct User: Codable {
    
    var nickname: String
    var email: String
    var profileImageURL: URL?
    var problemHistory: [ProblemRecord]
    
    init(nickname: String, email: String, profileImageURL: URL? = nil, problemHistory: [ProblemRecord] = []) {
        self.nickname = nickname
        self.email = email
        self.profileImageURL = profileImageURL
        self.problemHistory = problemHistory
    }
    
}

struct ProblemRecord: Codable {
    var date: Date
    var solvedProblemCount: Int
    var points: Int
}
