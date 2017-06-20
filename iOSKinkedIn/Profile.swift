//
//  Profile.swift
//  iOSKinkedIn
//
//  Created by alice on 2/26/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation

class SimpleProfile {
    var neoId: String
    var name: String
    
    init?(_ json: [String:Any]){
        guard let _id = json["uuid"] as? String else {
            return nil
        }
        
        guard let _name = json["name"] as? String else {
            return nil
        }
        
        self.neoId = _id
        self.name = _name
        
    }
    
}

class Profile {
    var neoId: String
    var name: String
    var age: Int
    var kinksMatched: Int
    var vouches: Int
    
    var bio: String?
    var genders: [String] = [String]()
    var roles: [String]?
    var kinks = [String]()
    var picture: String?
    var city: String?
    var picture_public_id: String?
    
    init?(_ neoId: String, json: [String:Any]){
     
        guard let profile = json["profile"] as? [String:Any] else {
            print("can't parse profile obj")
            return nil
        }
        
        guard let _name = profile["name"] as? String else {
            print("can't read name")
            return nil
        }
        guard let _age = profile["age"] as? Int else {
            print("can't read age")
            return nil
        }
        
        guard let _kic = json["kinks_matched"] as? Int
        else {
            print("can't read kinks matched")
            return nil
        }
        
        self.neoId = neoId
        self.name = _name
        self.age = _age
        self.kinksMatched = _kic
        
        if let _genders = profile["genders"] as? [String] {
            self.genders = _genders
        }
        
        if let _bio = profile["bio"] as? String {
            self.bio = _bio
        }
        
        if let _pictures = profile["pictures"] as? [String] {
            if(_pictures.count > 0){
                self.picture = _pictures[0].replacingOccurrences(of: "http:", with: "https:")
            }
        }
        
        if let _vouches = profile["vouches"] as? Int {
            self.vouches = _vouches
        } else {
            self.vouches = 0
        }
        
        if let _kinks = profile["kinks"] as? [Any] {
            for kink in _kinks {
                if let jsonKink = kink as? [String:Any] {
                    if let kinkLabel = jsonKink["label"] as? String {
                        self.kinks.append(kinkLabel)
                    }
                }
            }
        }
        
        
    }
    
    init(neoId: String, name: String,
         age: Int = 0,
         picture_public_id: String? = nil){
        self.neoId = neoId
        self.name = name
        self.age = age
        self.kinksMatched = 0
        self.vouches = 0
        self.picture_public_id = picture_public_id
    }
    
    
}
