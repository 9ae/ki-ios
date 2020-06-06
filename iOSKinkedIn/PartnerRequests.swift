//
//  PartnerRequests.swift
//  iOSKinkedIn
//
//  Created by alice on 4/30/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation

class PartnerRequest {
    var id: Int
    var from_uuid: String
    var from_name: String
    var from_image: String
    
    init?(json: [String: Any]){
        guard let _id = json["id"] as? Int else {
            return nil
        }
        self.id = _id
        
        guard let from = json["from_user"] as? [String: String] else {
            return nil
        }
        
        self.from_uuid = from["uuid"]!
        self.from_name = from["name"]!
        self.from_image = from["picture"]!
    }
}
