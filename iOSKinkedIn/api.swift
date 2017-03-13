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
            url += "?token=\(token)"
        }
        Alamofire.request(url).responseJSON { response in
            
            if let JSON = response.result.value as? [String:Any] {
                callback(JSON)
            } else {
                print("GET \(url)")
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
                    print("POST \(url)")
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
                                print("PUT \(url)")
                                print("error parsing json")
                            }
        }
    }
    
    static func delete(_ path: String, requiresToken: Bool = true,
                    callback: @escaping (_ json: [String:Any])-> Void) {
        var url = HOST_URL+path
        if(requiresToken){
            url += "?token=\(token)"
        }
        Alamofire.request(url,
                          method: .delete,
                          encoding: JSONEncoding.default).responseJSON { response in
                            
                            if let JSON = response.result.value as? [String:Any] {
                                callback(JSON)
                            } else {
                                print("DEL \(url)")
                                print("error parsing json")
                            }
        }
    }
    
    static func test(_ callback:@escaping(_ success:Bool)->Void ){
        Alamofire.request(HOST_URL).response { defaultDataResponse in
            callback( defaultDataResponse.error == nil)
        }
    }
    
    static func genders(_ callback:@escaping(_ results:[Gender])->Void ) {
        var genders = [Gender]()
        
        get("list/genders", requiresToken: false){ json in
            if let list = json["genders"] as? [Any] {
                for li in list {
                    if let gd = li as? String{
                        genders.append(Gender(label: gd))

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
    
    static func kinks(form: String, callback: @escaping(_ results:[Kink]) -> Void) {
        var kinks = [Kink]()
        print("fetchink \(form) kinks")
        get("kinks/\(form)", requiresToken: false){ json in
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
                    if let gd = li as? String {
                            roles.append(Role(label: gd))
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
        get("discover/profiles"){ json in
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
    
    static func readProfile(_ uuid: String, callback: @escaping(_ profile: Profile)->Void) {
        get("profile/\(uuid)"){ json in
            if let user = Profile(uuid, json: json) {
                callback(user)
            } else {
                print("request error in readProfile")
                // TODO: throws error
            }
        }
    }
    
    static func likeProfile(_ uuid: String, callback: @escaping(_ reciprocal: Bool)->Void ){
        let params : Parameters = [ "likes": true ]
        post("profile/\(uuid)", parameters: params){ json in
            let reciprocal = (json["reciprocal"] as? Bool) ?? false
            callback(reciprocal)
        }
    }
    
    static func skipProfile(_ uuid: String){
        let params : Parameters = [ "likes": false ]
        post("profile/\(uuid)", parameters: params){ json in
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
    
    static func addKinks(_ body:[String: Any]){
        post("self/kinks", parameters: body){json in
            print(json)
        }
    }
    
    static func addKink(_ id: Int, way: String, exp: Int){
        let params: [String: Any] = [
            "ways": way,
            "exp": exp
        ]
        post("self/kinks/\(id)", parameters: params){json in
            print(json)
        }
    }
    
    static func updateKink(_ id: Int, way: String, exp: Int){
        let params: [String: Any] = [
            "ways": way,
            "exp": exp
        ]
        put("self/kinks/\(id)", parameters: params){json in
            print(json)
        }
    }
    
    static func deleteKink(_ id: Int){
        delete("self/kinks/\(id)"){ json in
            print(json)
        }
    }
    
    static func connections(callback: @escaping(_ profiles: [Profile])-> Void){
        get("/self/connections"){ json in
            
            var profiles = [Profile]()
            guard let reciprocals = json["reciprocals"] as? [Any] else {
                print("list not found")
                return
            }
            
            for r in reciprocals {
                guard let rc = r as? [String:Any] else {
                    print("can't get json object")
                    continue
                }
                guard let name = rc["name"] as? String,
                let neo_id = rc["neo_id"] as? String,
                    let image_id = rc["image_id"] as? String else {
                        print("can't get profile values")
                        continue
                }
                profiles.append(Profile(neoId: neo_id, name: name, picture_public_id: image_id))
                
            }
            
            callback(profiles)
        }
    }
}
