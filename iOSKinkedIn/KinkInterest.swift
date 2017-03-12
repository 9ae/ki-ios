//
//  KinkInterest.swift
//  iOSKinkedIn
//
//  Created by alice on 2/20/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation
import RealmSwift

let experiences = ["curious about", "dabbled with", "learning", "practicing", "skilled in", "master of"]

class Kink {
    var label: String
    var code: String
    var popularity: Int
    var checked: Bool
    var likeWay: String
    var exp: Int

    init?(json: [String:Any]){
        guard let _label = json["label"] as? String,
            let _id = json["code"] as? String
            else {
                return nil
        }
        self.label = _label
        self.code = _id
        
        if let _pop = json["popularity"] as? Int {
            self.popularity = _pop
        } else {
            self.popularity = 0
        }
        self.checked = false
        self.likeWay = ""
        self.exp = 0
    }
}

/*
class KinkInterest: Object {
    
    dynamic var code = ""
    dynamic var way = 0
    dynamic var form = ""
    
    static func addKink(_ code: String, way: Int, form: String) {
        let realm = RealmDB.instance()
        let predicate = NSPredicate(format: "code = %@", code)
        let results = realm.objects(KinkInterest.self).filter(predicate)
        
        if (results.count==1){
            let ki = results[0]
            if (ki.form in ("SERVICE", "WEARABLE")){
                ki.way += way
            }
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
        
        let predicate = NSPredicate(format: "code = %@", _label)
        let results = realm.objects(KinkInterest.self).filter(predicate)
        return results.count==1
    }
}
*/
