//
//  api.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation
import Alamofire

let HOST_URL = "https://private-859cb-theash.apiary-mock.com/"
//"https://dev.kinkd.in/"

class KinkedInAPI {

    static func get(_ path: String, callback:@escaping (_ json: [String:Any])->Void){
        Alamofire.request(HOST_URL+path).responseJSON { response in
            
            if let JSON = response.result.value as? [String:Any] {
                callback(JSON)
                
            }
        }
    }
  /*
    static func post(_ path: String, parameters: Parameters) -> NSURLRequest {
        return Alamofire.request(HOST_URL+path,
                                 method: "POST",
                                 parameters: parameters,
                                 encoding: JSONEncoding.default)
    }
    */
    
    static func genders(_ callback:@escaping(_ results:[Gender])->Void ) {
        var genders = [Gender]()
        Alamofire.request(HOST_URL+"genders").responseJSON { response in
            
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
    
    static func kinks(_ callback: @escaping(_ results:[Kink]) -> Void) {
        var kinks = [Kink]()
        Alamofire.request(HOST_URL+"kinks").responseJSON { response in
            if let json = response.result.value as? [String:Any] {
                if let list = json["kinks"] as? [Any] {
                    for li in list {
                        if let kd = li as? [String:Any] {
                            if let k = Kink(json:kd){
                                kinks.append(k)
                            }
                        }
                    }
                }
            }
            callback(kinks)
        }
    }
    
    static func roles(_ callback:@escaping(_ results:[Role])->Void ) {
        var roles = [Role]()
        Alamofire.request(HOST_URL+"roles").responseJSON { response in
            
            if let json = response.result.value as? [String:Any] {
                if let list = json["roles"] as? [Any] {
                    for li in list {
                        if let gd = li as? [String:Any] {
                            if let g = Role(json:gd){
                                roles.append(g)
                            }
                        }
                    }
                }
                
            }
            callback(roles)
        }
    }
    
    static func login(email: String, password: String, callback: @escaping(_ neoId: String)->Void){
        
        let params: Parameters = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(HOST_URL+"login",
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default).responseJSON{ response in
                if let json = response.result.value as? [String:Any] {
                    if let token = json["token"] as? String {
                        Login.setToken(token)
                    }
                    if let neoId = json["neo_id"] as? String {
                        callback(neoId)
                    }
                    //TODO #2 login failed messages via notification system
                }
        
        }
    }
    
    static func validate(_ token: String, callback:@escaping (_ neoId: String)->Void) {
        
        Alamofire.request(HOST_URL+"validate?token=\(token)").responseJSON{ response in
            if let json = response.result.value as? [String:Any] {
                if let neoId = json["neo_id"] as? String {
                    callback(neoId)
                }
            } else {
                print("error parsing json")
            }
        }
        
    }
    
    static func register(email: String, password: String, inviteCode: String, callback: @escaping(_ success:Bool)->Void){
        let params: Parameters = [
            "email": email,
            "password": password,
            "invite_code": inviteCode
        ]
        
        Alamofire.request(HOST_URL+"register",
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default).responseJSON{ response in
                            if let json = response.result.value as? [String:Any] {
                                if let success = json["success"] as? Bool {
                                    callback(success)
                                } else {
                                    callback(false)
                                }
                            } else {
                                callback(false)
                            }
        }
    }
}
