//
//  Profile.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation
import RealmSwift

class Profile: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    dynamic var neoId: String = ""
    dynamic var isSelf: Bool = false
    
    dynamic var name: String = ""
    dynamic var birthday: Date?
    dynamic var bio: String = ""
    
    dynamic var genderIds: String = ""
    dynamic var roleIds: String = ""
    
    
    static func me() -> Profile? {
        return nil
    }
    
    static func get(_ neo: String) -> Profile? {
        let realm = RealmDB.instance()
        
        let predicate = NSPredicate(format: "neoId = %@ AND isSelf = true", neo)
        let results = realm.objects(Profile.self).filter(predicate)
        
        if (results.count==1){
            return results[0]
        } else {
            return nil
        }
    }
    
    static func create(_ neo: String, isSelf: Bool = false) -> Profile {

        var profile = Profile()
        profile.neoId = neo
        profile.isSelf = isSelf
        RealmDB.save(profile)
        return profile

    }
    
    func saveGenders(_ ids: [Int]) {
        let idStr = joinIds(ids)
        let realm = RealmDB.instance()
        try! realm.write {
            self.genderIds = idStr
        }
        
    }
    
}
