//
//  Gender.swift
//  iOSKinkedIn
//
//  Created by alice on 3/14/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation

struct Gender {
    var label: String
}

extension Gender {
    init?(json: [String: Any]){
        guard let _label = json["label"] as? String
            else {
                return nil
        }
        self.label = _label
    }
    
    static func parseJsonList(_ list: [String]) -> [Gender] {
        var genders = [Gender]()
        for li in list {
            genders.append(Gender(label: li))
        }
        return genders
    }
}
