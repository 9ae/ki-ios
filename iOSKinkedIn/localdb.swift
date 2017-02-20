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
            _db = try! Realm.init(
                //TODO Remove this for prod
                fileURL: (URL(string: "/Users/alice/Workspaces/ki/db/irealm/default.realm"))!)
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
    
    static func backgroundsave(_ callback: ()-> Void) {
        // Import many items in a background thread
        DispatchQueue.global().async {
            // Get new realm and table since we are in a new thread
            let realm = instance()
            realm.beginWrite()
            
            try! realm.commitWrite()
        }
    }
    
}
