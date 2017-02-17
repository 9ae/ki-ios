//
//  localdb.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDB {
    
    private static var _db: Realm?
    
    static func instance() -> Realm {
        if(_db == nil){
            _db = try! Realm()
        }
        return _db!
    }

    static func save(_ modelInstance: Object){
        let realm = instance()
        realm.beginWrite()
        realm.add(modelInstance)
        try! realm.commitWrite()
    }
    
    static func delete(_ modelInstance: Object){
        let realm = instance()
        try! realm.write {
            realm.delete(modelInstance)
        }
    }
    
}
