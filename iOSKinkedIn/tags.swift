//
//  tags.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation

struct Gender {
    var id: Int
    var label: String
}

extension Gender {
    init?(json: [String: Any]){
        guard let _id = json["id"] as? Int,
        let _label = json["label"] as? String
        else {
            return nil
        }
        self.id = _id
        self.label = _label
    }
}


struct Kink {
    var label: String
    var popularity: Int
    var ways: [String]
}

extension Kink {
    init?(json: [String:Any]){
        guard let _label = json["label"] as? String,
            let _pop = json["popularity"] as? Int
            else {
                    return nil
            }
        self.label = _label
        self.popularity = _pop
        self.ways = [String]()
        
        if let _ways = json["ways"] as? [String] {
            self.ways = _ways
        }
    }
}

struct Role {
    var id: Int
    var label: String
}

extension Role {
    init?(json: [String: Any]){
        guard let _id = json["id"] as? Int,
            let _label = json["label"] as? String
            else {
                return nil
        }
        self.id = _id
        self.label = _label
    }
}