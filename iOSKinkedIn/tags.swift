//
//  tags.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
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
}


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
}
