//
//  Login.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation
import RealmSwift

class Login: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    dynamic var timestamp: Date?
    dynamic var token: String?
    
    static func getToken() -> String? {
        
        let realm = RealmDB.instance()
        let logins = realm.objects(Login.self)
        
        if (logins.count==1){
            //TODO #1 check timestamp is not more than a 2 months
            // If expired delete this token
            return logins[0].token!
        } else {
            return nil
        }
    }
    
    static func setToken(_ token:String){
        let login = Login()
        login.token = token
        login.timestamp = Date.init()
        RealmDB.save(login)
    }

}
