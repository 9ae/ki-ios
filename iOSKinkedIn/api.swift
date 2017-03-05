//
//  api.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation
import Alamofire

let HOST_URL = "https://kinkedin-dev.herokuapp.com/"
//"https://private-859cb-theash.apiary-mock.com/"
//"https://dev.kinkd.in/"

enum ProfileAction: Int {
    case hide=0, skip, like
}

class KinkedInAPI {
    
    static var token: String = ""
    
    static func setToken(_ t: String){
        token = t
    }

    static func get(_ path: String, requiresToken: Bool = true, callback:@escaping (_ json: [String:Any])->Void){
        var url = HOST_URL+path
        if(requiresToken){
            url += "?\(token)"
        }
        Alamofire.request(url).responseJSON { response in
            
            if let JSON = response.result.value as? [String:Any] {
                callback(JSON)
            } else {
                print(url)
                print("error parsing json")
            }
        }
    }
  
    static func post(_ path: String, parameters: [String: Any], requiresToken: Bool = true,
                     callback: @escaping (_ json: [String:Any])-> Void) {
        let url = HOST_URL+path
        var params: Parameters = parameters
        if(requiresToken){
            params["token"] = token
        }
        Alamofire.request(url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default).responseJSON { response in
                
                if let JSON = response.result.value as? [String:Any] {
                    callback(JSON)
                } else {
                    print(url)
                    print("error parsing json")
                }
        }
    }
    
    static func put(_ path: String, parameters: [String: Any], requiresToken: Bool = true,
                     callback: @escaping (_ json: [String:Any])-> Void) {
        let url = HOST_URL+path
        var params: Parameters = parameters
        if(requiresToken){
            params["token"] = token
        }
        Alamofire.request(url,
                          method: .put,
                          parameters: params,
                          encoding: JSONEncoding.default).responseJSON { response in
                            
                            if let JSON = response.result.value as? [String:Any] {
                                callback(JSON)
                            } else {
                                print(url)
                                print("error parsing json")
                            }
        }
    }
    
    static func delete(_ path: String, requiresToken: Bool = true,
                    callback: @escaping (_ json: [String:Any])-> Void) {
        var url = HOST_URL+path
        if(requiresToken){
            url += "?\(token)"
        }
        Alamofire.request(url,
                          method: .delete,
                          encoding: JSONEncoding.default).responseJSON { response in
                            
                            if let JSON = response.result.value as? [String:Any] {
                                callback(JSON)
                            } else {
                                print(url)
                                print("error parsing json")
                            }
        }
    }
    
    static func genders(_ callback:@escaping(_ results:[Gender])->Void ) {
        var genders = [Gender]()
        
        get("list/genders", requiresToken: false){ json in
            if let list = json["genders"] as? [Any] {
                for li in list {
                    if let gd = li as? [String:Any] {
                        if let g = Gender(json:gd){
                            genders.append(g)
                        }
                    }
                }
            }
            callback(genders)
        }
    }
    
    static func kinks(_ callback: @escaping(_ results:[Kink]) -> Void) {
        var kinks = [Kink]()
        
        get("kinks", requiresToken: false){ json in
            if let list = json["kinks"] as? [Any] {
                for li in list {
                    if let kd = li as? [String:Any] {
                        if let k = Kink(json:kd){
                            kinks.append(k)
                        }
                    }
                }
            }
            callback(kinks)
        }
    }
    
    static func roles(_ callback:@escaping(_ results:[Role])->Void ) {
        var roles = [Role]()
        
        get("list/roles", requiresToken: false){ json in
            if let list = json["roles"] as? [Any] {
                for li in list {
                    if let gd = li as? [String:Any] {
                        if let g = Role(json:gd){
                            roles.append(g)
                        }
                    }
                }
            }
            callback(roles)
        }
        
    }
    
    static func login(email: String, password: String, callback: @escaping(_ token: String)->Void){
        
        let params: Parameters = [
            "email": email,
            "password": password
        ]
        
        post("login", parameters: params, requiresToken: false){ json in
            if let token = json["token"] as? String {
                Login.setToken(token)
                self.setToken(token)
                callback(token)
            }
            /*
            if let neoId = json["neo_id"] as? String {
                callback(neoId)
            }
            */
            //TODO #2 login failed messages via notification system
        }
    }
   /*
    static func validate(_ token: String, callback:@escaping (_ neoId: String)->Void) {
        
        get("self/validate"){ json in
            if let neoId = json["neo_id"] as? String {
                callback(neoId)
            }
        }
        
    }
    */
    static func register(email: String, password: String, inviteCode: String, callback: @escaping(_ success:Bool)->Void){
        let params: Parameters = [
            "email": email,
            "password": password,
            "invite_code": inviteCode
        ]
        
        post("register", parameters: params, requiresToken: false){ json in
            if let success = json["success"] as? Bool {
                callback(success)
                /* set token somewhere if need be
                 if let neoId = json["neo_id"] as? String {
                 callback(neoId)
                 }
                 */
            } else {
                callback(false)
            }
        }
    }
    
    static func listProfiles(callback: @escaping(_ uuids: [String])->Void ){
        get("profiles"){ json in
            let count = (json["count"] as? Int) ?? 0
            if(count>0){
                if let uuids = json["users"] as? [String] {
                    callback(uuids)
                }
            } else {
                callback([])
            }
        }
    }
    
    static func readProfile(_ uuid: String, callback: @escaping(_ profile: ViewProfile)->Void) {
        get("profiles/\(uuid)"){ json in
            if let user = ViewProfile(json) {
                print(user)
                callback(user)
            } else {
                print("request error in readProfile")
                // TODO: throws error
            }
        }
    }
    
    static func likeProfile(_ uuid: String, callback: @escaping(_ reciprocal: Bool)->Void ){
        let params : Parameters = [ "action": ProfileAction.like ]
        post("profiles/\(uuid)", parameters: params){ json in
            let reciprocal = (json["reciprocal"] as? Bool) ?? false
            callback(reciprocal)
        }
    }
    
    static func markProfile(_ uuid: String, action: ProfileAction){
        let params : Parameters = [ "action": action.rawValue ]
        post("profiles/\(uuid)", parameters: params){ json in
            // assert json["success"] == true
        }
    }
    
    static func checkProfileSetup(callback: @escaping(_ step: Int)->Void ){
        get("self/check_setup"){ json in
            let step = json["step"] as? Int ?? 0
            callback(step)
        }
    }
    
    static func updateProfile(_ body: [String: Any]) {
        put("self/profile", parameters: body){ json in
            print(json)
        }
    
    }
    
}
