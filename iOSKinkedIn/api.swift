//
//  api.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation
import Alamofire
import PusherSwift

let HOST_URL = "https://kinkedin-dev.herokuapp.com/"

enum ProfileAction: Int {
    case hide=0, skip, like
}

class Woz {
    var id: String
    var complete: Bool
    var result: Any?
    
    private var its = 0
    private var timer: Timer?
    private var requiresToken = true
    
    private var completeCallback: ((Any?) -> Void)?
    
    init(_ json:[String: Any], callback: @escaping (Any?) -> Void){
        if let _id = json["job_id"] as? String {
            self.id = _id
            if let _complete = json["complete"] as? Bool {
                self.complete = _complete
            } else {
                self.complete = false
            }
            self.result = json["result"]
            self.completeCallback = callback
        } else{
            self.id = ""
            self.complete = true
            self.result = nil
            self.completeCallback = nil
        }
    }

    
    func run(requiresToken: Bool){
        if(self.complete){
            doFinale()
        }
        else {
            self.requiresToken = requiresToken
            self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.checkJob), userInfo: nil, repeats: true)
        }
    }
    
    private func responder(json: [String: Any]){
        self.complete = (json["complete"] as? Bool) ?? false
        if(self.complete){
            self.timer?.invalidate()
            self.result = json["result"]

            self.completeCallback?(self.result)

            print("job completes after \(its) iterations")
        }
    }
    
    @objc
    func checkJob(){
        if(its > 30){
            self.timer?.invalidate()
        }
 
        let path = (requiresToken ? "self/" : "" ) + "job/\(self.id)"
        KinkedInAPI.get(path, requiresToken: requiresToken, callback: self.responder)
        
        its += 1
    }
    
    func doFinale(){
        self.completeCallback?(self.result)
    }
    
}

class KinkedInAPI {
    
    static var token: String = ""
    
    static func setToken(_ t: String){
        token = t
        setChannel()
    }

    static func get(_ path: String, requiresToken: Bool = true, callback:@escaping (_ json: [String:Any])->Void){
        var url = HOST_URL+path
        if(requiresToken){
            if(path.contains("?")){
                url += "&token=\(token)"
            } else {
                url += "?token=\(token)"
            }
            
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
        get("list/genders", requiresToken: false){ json in
            let job = Woz(json){ result in
                if let list = result as? [String] {
                    let genders = Gender.parseJsonList(list)
                    callback(genders)
                }
            }

            job.run(requiresToken: false)
        }
    }

    static func kinks(form: String, callback: @escaping(_ results:[Kink]) -> Void) {
        
        print("fetching \(form) kinks")
        get("kinks/\(form)", requiresToken: false){ json in
            let job = Woz(json, callback: { result in
                if let list = result as? [Any] {
                    let kinks = Kink.parseJsonList(list)
                    callback(kinks)
                }
            })
            

            job.run(requiresToken: false)
        }
    }
    
    static func roles(_ callback:@escaping(_ results:[Role])->Void ) {
        
        get("list/roles", requiresToken: false){ json in
            let job = Woz(json){ result in
                if let list = result as? [String] {
                    let roles = Role.parseJsonList(list)
                    callback(roles)
                }
            }
            
            job.run(requiresToken: false)
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
    
    static func register(email: String, password: String, inviteCode: String, callback: @escaping(_ success:Bool)->Void){
        let params: Parameters = [
            "email": email,
            "password": password,
            "invite_code": inviteCode
        ]
        post("register", parameters: params, requiresToken: false){ json in
            let job = Woz(json){ result in
                if let token = result as? String {
                    Login.setToken(token)
                    self.setToken(token)
                    callback(true)
                } else {
                    callback(false)
                }
            }
            job.run(requiresToken: false)
            
        }
    }
    
    private static func setChannel() {
        print("subscribe to my own channel")
        get("self/pusheen"){ json in
            if let neoId = json["my_channel"] as? String {
                let pusher = Pusher(key: "24ee5765edd3a7a2bf66")
                pusher.nativePusher.subscribe(interestName: neoId)
            }
        }
        
    }
    
    static func listProfiles(callback: @escaping(_ uuids: [String])->Void ){
        get("discover/profiles"){ json in
            let job = Woz(json){ result in
                let uuids = result as? [String] ?? []
                callback(uuids)
            }
            job.run(requiresToken: true)
        }
    }
    
    static func readProfile(_ uuid: String, callback: @escaping(_ profile: Profile)->Void) {
        get("profile/\(uuid)"){ json in
            let job = Woz(json){ result in
                if let user = Profile(uuid, json: result as! [String:Any]) {
                    callback(user)
                } else {
                    print("error in parsing profile")
                }
            }
            job.run(requiresToken: true)
        }
    }
    
    static func likeProfile(_ uuid: String, callback: @escaping(_ reciprocal: Bool)->Void ){
        let params : Parameters = [ "likes": true ]
        post("profile/\(uuid)", parameters: params){ json in
            let job = Woz(json){ result in
                let reciprocal = (result as? Bool) ?? false
                callback(reciprocal)
            }
            job.run(requiresToken: true)
        }
    }
    
    static func skipProfile(_ uuid: String){
        let params : Parameters = [ "likes": false ]
        post("profile/\(uuid)", parameters: params){ json in
            print(json)
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
    
    static func connections(callback: @escaping(_ profiles: [Profile])-> Void){
        get("self/connections"){ json in
            let job = Woz(json){ result in
                var profiles = [Profile]()
                guard let reciprocals = result as? [Any] else {
                    print("failed to cast list")
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
            job.run(requiresToken: true)
            
        }
    }
    
    private static func makePartnerRequest(partnerId: String){
        let params = ["partner_uuid": partnerId]
        print("POST self/partner_requests")
        print(params)
    }
    
    static func addPartner(_ email: String, callback: @escaping(_ partnerFound: Bool)->Void){
        get("self/find_user?email=\(email)"){ json in
            if let partnerId = json["partner_uuid"] as? String {
                callback(true)
                makePartnerRequest(partnerId: partnerId)
            } else {
                callback(false)
            }
        }
    }
}
