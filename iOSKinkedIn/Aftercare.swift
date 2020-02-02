//
//  Aftercare.swift
//  iOSKinkedIn
//
//  Created by Alice on 2/2/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import Foundation

enum ReplyType: String, Codable {
    case question, choice
}

struct CareQuestion : Codable {
    var id: Int
    var message: String
    var type : ReplyType
    var followup: [CareQuestion]
    
    init?(_ json: [String:Any]){
        guard let id = json["name"] as? Int else {return nil}
        guard let content = json["content"] as? String  else {return nil}
        guard let type = json["type"] as? String else {return nil}
        
        self.id = id
        self.message = content
        
        self.type = (type == "choice" ? .choice : .question)
        
        self.followup = []
        if let children = json["children"] as? [[String:Any]] {
            for child in children {
                if let q = CareQuestion.init(child) {
                    self.followup.append(q)
                }
            }
        }
    }
}
