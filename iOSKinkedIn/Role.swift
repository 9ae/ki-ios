//
//  Role.swift
//  iOSKinkedIn
//
//  Created by alice on 3/14/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation

struct Role {
    var label: String
}

extension Role {
    init?(json: [String: Any]){
        guard let _label = json["label"] as? String
            else {
                return nil
        }
        self.label = _label
    }
    
    static func parseJsonList(_ list: [String]) -> [Role] {
        var roles = [Role]()
        for li in list {
            roles.append(Role(label: li))
        }
        return roles
    }
}
