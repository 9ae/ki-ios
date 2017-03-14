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
    
    var form: KinkForm
    var exp: Int
    
    var likesGive = false
    var likesGet = false
    var likesBoth = false
    
    // to deprecate?
    var likeWay: String
    var checked: Bool
    var popularity: Int


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
        
        if let _form = json["form"] as? String {
            self.form = KinkForm.init(rawValue: _form) ?? KinkForm.other
        } else {
            self.form = KinkForm.other
        }
        
        self.checked = false
        self.likeWay = ""
        self.exp = 0
    }
    
    static func parseJsonList(_ list: [Any]) -> [Kink] {
        var kinks = [Kink]()
        
        for li in list {
                if let kd = li as? [String:Any] {
                    if let k = Kink(json:kd){
                        kinks.append(k)
                    }
                }
            }
        
        return kinks
    }
}

enum KinkForm: String {
    case service = "SERVICE"
    case wearable = "WEARABLE"
    case act = "ACT"
    case other = "OTHER"
    case accessory = "ACCESSORY"
    case aphrodisiac = "APHRODISIAC"
}

/*
class KinkInterest: Object {
    
    dynamic var code = ""
    dynamic var label = ""
    dynamic var way = 0
    dynamic var form = 0
    
    /*
    static func has(_label: String) -> Bool {
        let realm = RealmDB.instance()
        
        let predicate = NSPredicate(format: "code = %@", _label)
        let results = realm.objects(KinkInterest.self).filter(predicate)
        return results.count==1
    }
    */
}
*/
