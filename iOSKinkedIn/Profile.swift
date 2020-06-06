//
//  Profile.swift
//  iOSKinkedIn
//
//  Created by alice on 2/26/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation

struct BioPrompt : Codable {
    
    var title: String
    var answer: String?
    var show: Bool = false
    
    func objectify() -> [String: Any?]{
        return [
            "title": self.title,
            "show": self.show,
            "answer": self.answer
        ]
    }
    
}

struct PreferenceFilters : Codable {
    
    var minAge: Int
    var maxAge: Int
    var genders: [String]
    var roles: [String]

}

struct City : Codable {
    var code: String
    var label: String
}

struct ConvoPreview : Codable {
    var timestamp: Date
    var text: String
    var isent: Bool
}

class Profile  : Codable {
    var uuid: String
    var name: String
    var age: Int
    var kinksMatched: Int
    var vouches: Int
    
    var bio: String?
    var genders: [String] = [String]()
    var roles: [String] = [String]()
    var kinks = [Kink]()
    var city: String?
    var birthday: Date?
    var prompts : [BioPrompt]?
    
    var setup_complete: Bool = false
    var is_myself: Bool = false
    var expLv: Int?
    var exp: String?
    
    var th_picture: String?
    var pictures: [String] = []
    
    var convo: ConvoPreview?
    
    var preferences: PreferenceFilters?
    
    init?(_ json: [String:Any]){
        guard let _id = json["uuid"] as? String else {
            return nil
        }
        
        guard let _name = json["name"] as? String else {
            return nil
        }
        
        self.uuid = _id
        self.name = _name
        self.age = 0
        self.kinksMatched = 0
        self.vouches = 0
        
        if let kic = json["kinks_matched"] as? Int {
            self.kinksMatched = kic
        }
        
        if let image_url = json["picture"] as? String {
            self.th_picture = image_url
        }
        
        if let _vouches = json["vouches"] as? Int {
            self.vouches = _vouches
        }
    }
    
    init?(_ uuid: String, json: [String:Any]){
     
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
        
        self.uuid = uuid
        self.name = _name
        self.age = _age
        self.kinksMatched = _kic
        
        if let _genders = profile["genders"] as? [String] {
            self.genders = _genders
        }
        
        if let _roles = profile["roles"] as? [String] {
            self.roles = _roles
        }
        
        if let _bio = profile["bio"] as? String {
            self.bio = _bio
        }
        
        if let _pictures = profile["pictures"] as? [String] {
            self.pictures = _pictures
        }
        
        if let _vouches = profile["vouches"] as? Int {
            self.vouches = _vouches
        } else {
            self.vouches = 0
        }
        
        if let _kinks = profile["kinks"] as? [Any] {
            for kink in _kinks {
                if let jsonKink = kink as? [String:Any] {
                    if let k = Kink(jsonKink) {
                        self.kinks.append(k)
                    }
                }
            }
        }
        
        if let _prompts = profile["prompts"] as? [Any] {
            self.prompts = Profile.parsePrompts(_prompts)
        }
        
        
    }
    
    init(uuid: String, name: String,
         age: Int = 0,
         picture: String? = nil){
        self.uuid = uuid
        self.name = name
        self.age = age
        self.kinksMatched = 0
        self.vouches = 0
        self.th_picture = picture
    }
    
    func isFull() -> Bool {
        return  (self.bio != nil) || (!self.pictures.isEmpty) || (self.city != nil) || (self.th_picture != nil) || (self.prompts != nil)
    }

    
    func kinkLabels() -> [String] {
        let labels : [String] = self.kinks.map({ (kink: Kink) -> String in
            return kink.label
        })
        return labels
    }
    
    func setBirthday(_ date: String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.birthday = dateFormatter.date(from: date)
    }
    
    func hasName() -> Bool{
        return self.name != ""
    }
    
    func hasAge() -> Bool{
        return self.age != 0
    }
    
    static func parseSelf(_ json: [String:Any]) -> Profile {
        let pro = Profile(uuid: "", name: "", age: 0)
        
        if let _name = json["name"] as? String {
            pro.name = _name
        }
        
        if let _age = json["age"] as? Int {
            pro.age = _age
        }
        
        if let _genders = json["genders"] as? [String] {
            pro.genders = _genders
        }
        
        if let _roles = json["roles"] as? [String] {
            pro.roles = _roles
        }
        
        if let _birthday = json["birthday"] as? String {
           pro.setBirthday(_birthday)
        }
        
        if let _pictures = json["pictures"] as? [String] {
            pro.pictures = _pictures
        }
        
        if let _kinks = json["kinks"] as? [Any] {
            for kink in _kinks {
                if let jsonKink = kink as? [String:Any] {
                    if let k = Kink(jsonKink) {
                        pro.kinks.append(k)
                    }
                }
            }
        }
        
        if let _step = json["setup_complete"] as? Bool {
            pro.setup_complete = _step
        }
        
        if let _expLv = json["exp_level"] as? Int {
            pro.expLv = _expLv
        }
        
        if let _exp = json["exp"] as? String {
            pro.exp = _exp
        }
        
        if let _prompts = json["prompts"] as? [Any] {
            pro.prompts = Profile.parsePrompts(_prompts)
        }
        
        if let _prefers = json["prefers"] as? [String:Any]{
            let minAge = (_prefers["min_age"] as? Int) ?? 0
            let maxAge = (_prefers["max_age"] as? Int) ?? 0
            let genders = (_prefers["genders"] as? [String]) ?? [String]()
            let roles = (_prefers["roles"] as? [String]) ?? [String]()
            pro.preferences = PreferenceFilters(minAge: minAge, maxAge: maxAge, genders: genders, roles: roles)
        }
        
        if let _city = json["city"] as? String {
            pro.city = _city
        }
        
        return pro
    }
    
    static func parsePrompts(_ arr: [Any]) -> [BioPrompt]? {
        var results = [BioPrompt]()
        for _pr in arr {
            if let _p = _pr as? [String: Any] {
                guard let _title = _p["title"] as? String else {
                    continue
                }
                
                guard let _show = _p["show"] as? Bool else {
                    continue
                }
                
                let _answer = _p["answer"] as? String
                
                let bp = BioPrompt(title: _title, answer: _answer, show: _show)
                results.append(bp)
            }
        }
        
        if(results.count>0){
            print("parsed successful")
            return results
        } else {
            print("parse failed")
            return nil
        }
    }
    
    
}
