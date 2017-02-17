//
//  api.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation
import Alamofire

let HOST_URL = "https://dev.kinkd.in/"

class KinkedInAPI {

    static func get(_ path: String, callback:@escaping (_ json: [String:Any])->Void){
        Alamofire.request(HOST_URL+path).responseJSON { response in
            
            if let JSON = response.result.value as? [String:Any] {
                callback(JSON)
                
            }
        }
    }
    
    
    static func genders(_ callback:@escaping(_ results:[Gender])->Void ) {
        var genders: [Gender] = [Gender]()
        Alamofire.request(HOST_URL+"list/genders").responseJSON { response in
            
            if let json = response.result.value as? [String:Any] {
                if let list = json["genders"] as? [Any] {
                    for li in list {
                        if let gd = li as? [String:Any] {
                            if let g = Gender(json:gd){
                                genders.append(g)
                            }
                        }
                    }
                }
                
            }
            callback(genders)
        }
    }
}
