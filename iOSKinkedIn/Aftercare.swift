//
//  Aftercare.swift
//  iOSKinkedIn
//
//  Created by Alice on 2/2/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import Foundation

struct Message {
    let body : String
    let isMe : Bool
}

enum ReplyType: String, Codable {
    case statement, choice, option, question
}

struct CareQuestion : Codable {
    var id: Int
    var message: String
    var type : ReplyType
    var followup: [CareQuestion]
    
    init?(_ json: [String:Any]){
        guard let id = json["id"] as? Int else {return nil}
        guard let content = json["message"] as? String  else {return nil}
        guard let type = json["type"] as? String else {return nil}
        
        self.id = id
        self.message = content
        
        self.type = ReplyType.init(rawValue: type) ?? .statement
        
        self.followup = []
        if let children = json["children"] as? [[String:Any]] {
            for child in children {
                if let q = CareQuestion.init(child) {
                    self.followup.append(q)
                }
            }
        }
    }
    
    init(_ message: String, type: ReplyType, followup: [CareQuestion]){
        self.id = Int.random(in: 0..<100)
        self.message = message
        self.type = type
        self.followup = followup
    }
}
