//
//  KinkInterest.swift
//  iOSKinkedIn
//
//  Created by alice on 2/20/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation

let experiences = ["curious about", "dabbled with", "learning", "practicing", "skilled in", "master of"]

enum way : String, Codable {
    case give  = "GIVE"
    case get = "GET"
    case both = "BOTH"
    case none = ""
}

enum KinkForm: String, Codable {
    case service = "SERVICE"
    case wearable = "WEARABLE"
    case act = "ACT"
    case other = "OTHER"
    case accessory = "ACCESSORY"
    case aphrodisiac = "APHRODISIAC"
}

class Kink : Codable {
    var label: String
    var code: String
    
    var form: KinkForm
    var exp: Int
    
    var way : way
    
    init(label: String, code: String, form: KinkForm, exp: Int, way: way){
        self.label = label
        self.code = code
        self.form = form
        self.exp = exp
        self.way = way
    }


    init?(_ json: [String:Any]){
        guard let _label = json["label"] as? String,
            let _id = json["code"] as? String
        else {
                return nil
        }
        self.label = _label
        self.code = _id
        
        if let _form = json["form"] as? String {
            self.form = KinkForm.init(rawValue: _form) ?? KinkForm.other
        } else {
            self.form = KinkForm.other
        }
        
        if let _exp =  json["exp"] as? Int {
            self.exp = _exp
        } else {
            self.exp = 0
        }
        
        if let _ways = json["ways"] as? String {
            switch(_ways){
                case "GIVE":
                    self.way = .give
                case "GET":
                    self.way = .get
                default:
                    self.way = .both
            }
        } else {
            self.way = .none
        }
        
    }
    
    static func parseJsonList(_ list: [Any]) -> [Kink] {
        var kinks = [Kink]()
        
        for li in list {
                if let kd = li as? [String:Any] {
                    if let k = Kink(kd){
                        kinks.append(k)
                    }
                }
            }
        
        return kinks
    }
}
