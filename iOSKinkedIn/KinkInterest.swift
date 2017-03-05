//
//  KinkInterest.swift
//  iOSKinkedIn
//
//  Created by alice on 2/20/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation
import RealmSwift

class Kink {
    var label: String
    var id: Int
    var popularity: Int
    var ways: [String]
    var checked: Bool

    init?(json: [String:Any]){
        guard let _label = json["label"] as? String,
            let _id = json["id"] as? Int
            else {
                return nil
        }
        self.label = _label
        self.id = _id
        
        if let _ways = json["ways"] as? [String] {
            self.ways = _ways
        } else {
            self.ways = [String]()
        }
        
        if let _pop = json["popularity"] as? Int {
            self.popularity = _pop
        } else {
            self.popularity = 0
        }
        self.checked = false
    }
}

class KinkInterest: Object {
    
    dynamic var label = ""
    dynamic var compactWays = ""
    
    
    static func getOrCreate(_label: String) -> KinkInterest {
        let realm = RealmDB.instance()
        
        let predicate = NSPredicate(format: "label = %@", _label)
        let results = realm.objects(KinkInterest.self).filter(predicate)
        
        if (results.count==1){
            return results[0]
        } else {
            let ki = KinkInterest()
            ki.label = _label
            realm.beginWrite()
            realm.add(ki)
            try! realm.commitWrite()
            return ki
        }
    }
    
    static func has(_label: String) -> Bool {
        let realm = RealmDB.instance()
        
        let predicate = NSPredicate(format: "label = %@", _label)
        let results = realm.objects(KinkInterest.self).filter(predicate)
        return results.count==1
    }
}
