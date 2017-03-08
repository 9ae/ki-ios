//
//  Profile.swift
//  iOSKinkedIn
//
//  Created by alice on 2/26/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation

struct Kinky {
    var label: String
    var ways: [String]
    var level: Int
}

class Profile {
    var neoId: String
    var name: String
    var age: Int
    var kinksMatched: Int
    
    var bio: String?
    var genders: [String] = [String]()
    var roles: [String]?
    var kinks: [Kinky]?
    var picture: String?
    var city: String?
    
    init?(_ json: [String:Any]){
     
        guard let _neoId = json["neo_id"] as? String,
            let _name = json["name"] as? String,
            let _age = json["age"] as? Int,
            let _kic = json["kinks_matched"] as? Int
            else {
                return nil
            }
        self.neoId = _neoId
        self.name = _name
        self.age = _age
        self.kinksMatched = _kic
        
        if let _genders = json["genders"] as? [Any] {
            for g in _genders {
                if let gender = g as? String {
                    self.genders.append(gender)
                }
            }
        }
        
        if let _bio = json["bio"] as? String {
            self.bio = _bio
        }
        
        if let _picture = json["picture"] as? String {
            self.picture = _picture
        }
        
    }
    
    init(neoId: String, name: String, age: Int){
        self.neoId = neoId
        self.name = name
        self.age = age
        self.kinksMatched = 0
    }
    
    
}