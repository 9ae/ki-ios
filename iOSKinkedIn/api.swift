//
//  api.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation
import Alamofire
import Cache

enum ProfileAction: Int {
    case hide=0, skip, like
}

class KinkedInAPI {
    
    static var token: String = ""
    static var deviceToken: Data?
    static let HOST_URL = Bundle.main.infoDictionary!["KI_API"] as! String
    
    static let ds = try! Storage(
        diskConfig: DiskConfig(name: "KiCache"),
        memoryConfig: MemoryConfig(),
        transformer: TransformerFactory.forData()
    )
    static let profileCache = ds.transformCodable(ofType: Profile.self)

    
    static let MAX_ITERATIONS = 20
    static let TIMER_DELAY = 2.0
    
    static func setToken(_ t: String){
        token = t
        
        NotificationCenter.default.post(name: NOTIFY_TOKEN_SET, object: nil)
        dailyLimits { (limit, matches) in
            UserDefaults.standard.set(limit, forKey: UD_MATCH_LIMIT)
            UserDefaults.standard.set(matches, forKey: UD_MATCHES_TODAY)
            UserDefaults.standard.set(matches < limit, forKey: UD_CAN_LIKE)
        }
    }

    static func get(_ path: String, requiresToken: Bool = true, isJob : Bool = false, it: Int = 0,  callback:@escaping (_ json: Any)->Void){
        var url = HOST_URL+path
        if(requiresToken){
            if(path.contains("?")){
                url += "&token=\(token)"
            } else {
                url += "?token=\(token)"
            }
            
        }
        print("XX GET [\(it)] \(url)")
        Alamofire.request(url).responseJSON { response in
            
            if let JSON = response.result.value as? [String:Any] {
                if(isJob && it < MAX_ITERATIONS){
                    let complete = JSON["complete"] as! Bool
                    if !complete {
                        DispatchQueue.main.asyncAfter(deadline: .now() + TIMER_DELAY, execute: {
                            get(path, requiresToken: requiresToken, isJob: isJob, it: it + 1, callback: callback)
                        })
                    } else {
                        callback(JSON["result"])
                    }
                }
                else  { callback(JSON) }
            } else {
                print("error parsing json")
            }
        }
    }
  
    static func post(_ path: String, parameters: [String: Any], requiresToken: Bool = true, isJob : Bool = false,  it: Int = 0,
                     callback: @escaping (_ json: Any)-> Void) {
        let url = HOST_URL+path
        var params: Parameters = parameters
        if(requiresToken){
            params["token"] = token
        }
        print("XX POST [\(it)] \(url)")
        Alamofire.request(url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default).responseJSON { response in
                
                if let JSON = response.result.value as? [String:Any] {
                    if(isJob && it < MAX_ITERATIONS){
                        let complete = JSON["complete"] as! Bool
                        if !complete {
                            DispatchQueue.main.asyncAfter(deadline: .now() + TIMER_DELAY, execute: {
                            post(path, parameters: parameters, requiresToken: requiresToken, isJob: isJob, it: it+1, callback: callback)
                            })
                            
                        } else {
                            callback(JSON["result"])
                        }
                    }
                    else { callback(JSON) }
                } else {
                    print("error parsing json")
                }
        }
    }
    
    static func put(_ path: String, parameters: [String: Any], requiresToken: Bool = true, isJob : Bool = false,  it: Int = 0,
                     callback: @escaping (_ json: Any)-> Void) {
        let url = HOST_URL+path
        var params: Parameters = parameters
        if(requiresToken){
            params["token"] = token
        }
        print("XX PUT [\(it)] \(url)")
        Alamofire.request(url,
                          method: .put,
                          parameters: params,
                          encoding: JSONEncoding.default).responseJSON { response in
                            
                            if let JSON = response.result.value as? [String:Any] {
                                if(isJob && it < MAX_ITERATIONS){
                                    let complete = JSON["complete"] as! Bool
                                    if !complete {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + TIMER_DELAY, execute: {
                                        put(path, parameters: parameters, requiresToken: requiresToken, isJob: isJob, it: it+1, callback: callback)
                                        })
                                        
                                    } else {
                                        callback(JSON["result"])
                                    }
                                }
                                else { callback(JSON) }
                            } else {
                                print("PUT \(url)")
                                print("error parsing json")
                            }
        }
    }
    
    static func delete(_ path: String, requiresToken: Bool = true, isJob : Bool = false,  it: Int = 0,
                    callback: @escaping (_ json: Any)-> Void) {
        var url = HOST_URL+path
        if(requiresToken){
            url += "?token=\(token)"
        }
        Alamofire.request(url,
                          method: .delete,
                          encoding: JSONEncoding.default).responseJSON { response in
                            
                            if let JSON = response.result.value as? [String:Any] {
                                if(isJob && it < MAX_ITERATIONS){
                                    let complete = JSON["complete"] as! Bool
                                    if !complete {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + TIMER_DELAY, execute: {
                                        delete(path, requiresToken: requiresToken, isJob: isJob, it:it+1, callback: callback)
                                        })
                                        
                                    } else {
                                        callback(JSON["result"])
                                    }
                                }
                                else { callback(JSON) }
                            } else {
                                print("DEL \(url)")
                                print("error parsing json")
                            }
        }
    }
    
    static func test(_ callback:@escaping(_ success:Bool)->Void ){
        print("testing server \(HOST_URL)")
        Alamofire.request(HOST_URL).response { defaultDataResponse in
            print(defaultDataResponse)
            callback( defaultDataResponse.error == nil)
        }
    }
    
    static func genders(_ callback:@escaping(_ results:[String])->Void ) {
        
        get("list/genders", requiresToken: false, isJob: true){ json in
            if let list = json as? [String] {
                callback(list)
            }
        }
    }

    static func kinks(form: String, callback: @escaping(_ results:[Kink]) -> Void) {
        
        print("fetching \(form) kinks")
        get("kinks/\(form)", requiresToken: false, isJob: true){ json in
            if let list = json as? [Any] {
                let kinks = Kink.parseJsonList(list)
                callback(kinks)
            }
        }
    }
    
    static func roles(_ callback:@escaping(_ results:[String])->Void ) {
        
        get("list/roles", requiresToken: false, isJob: true){ json in
            if let list = json as? [String] {
                callback(list)
            }
        }
        
    }
    
    static func experienceLevels(_ callback:@escaping(_ results:[String])->Void) {
        get("exp", requiresToken: false){ _json in
            guard let json = _json as? [String:Any] else { return }
            
            if let names = json["exp_names"] as? [String] {
                callback(names)
            }
        }
    }
    
    static func bioPrompts(_ callback:@escaping(_ results:[String])->Void) {
        get("prompts", requiresToken: false){ _json in
            guard let json = _json as? [String:Any] else { return }
            
            if let titles = json["prompts"] as? [String] {
                callback(titles)
            }
        }
    }
    
    static func cities(_ callback:@escaping(_ results:[City])->Void) {
        get("cities", requiresToken: false){_json in
            var cities = [City]()
            guard let json = _json as? [String:Any] else { return }
            if let arr = json["results"] as? [[String:Any]] {
                for e in arr {
                    if let code = e["code"] as? String,
                        let label = e["label"] as? String {
                        cities.append(City(code: code, label: label))
                    }
                }
            }
            callback(cities)
        }
    }
    
    static func login(email: String, password: String, callback: @escaping(_ success: Bool)->Void){
        
        let params: Parameters = [
            "email": email,
            "password": password
        ]
        
        post("login", parameters: params, requiresToken: false){ _json in
            guard let json = _json as? [String:Any] else { return }
            if let token = json["token"] as? String {
                KeychainWrapper.standard.set(token, forKey: "kiToken")
                self.setToken(token)
                callback(true)
            } else {
                callback(false)
            }
        }
    }
    
    static func logout(){
        get("logout", requiresToken: true){ json in
            print(json)
        }
    }
    
    static func register(email: String, password: String, inviteCode: String, callback: @escaping(_ success:Bool)->Void){
        let params: Parameters = [
            "email": email,
            "password": password,
            "invite_code": inviteCode
        ]
        post("register", parameters: params, requiresToken: false, isJob: true){ json in

            if let token = json as? String {
                KeychainWrapper.standard.set(token, forKey: "kiToken")
                self.setToken(token)
                callback(true)
            } else {
                callback(false)
            }
            
        }
    }
    
    static func listProfiles(callback: @escaping(_ profiles: [Profile])->Void ){
        get("discover/profiles"){ _json in
            guard let json = _json as? [String:Any] else { return }
            if let simple_profiles = json["result"] as? [Any] {
                var profiles = [Profile]()
                for pro in simple_profiles {
                    if let parsedProfile = Profile(pro as! [String:Any]) {
                        profiles.append(parsedProfile)
                    }
                }
                callback(profiles)
            }
        }
    }
    
    static func readProfile(_ uuid: String, callback: @escaping(_ profile: Profile)->Void) {
        do {
            let cachedProfile = try profileCache.object(forKey: uuid)
            print("YY found profile \(uuid) from cache")
            callback(cachedProfile)
        } catch {
            print("YY not found \(uuid) in cache")
            get("profile/\(uuid)", isJob: true){ json in
                
                if let user = Profile(uuid, json: json as! [String:Any]) {
                    try? profileCache.setObject(user, forKey: uuid)
                    callback(user)
                } else {
                    print("error in parsing profile")
                }
            }
            
        }
    }
    
    static func likeProfile(_ uuid: String,callback: @escaping(_ reciprocal: Bool,
        _ match_limit: Int, _ matches_today: Int)->Void ){
        let params : Parameters = [ "likes": true ]
        post("profile/\(uuid)", parameters: params, isJob: true){ json in

            guard let res = json as? [String: Any] else {
                return
            }
            
            let requited = res["requited"] as? Bool ?? false
            let match_limit = res["match_limit"] as? Int ?? UD_MATCH_LIMIT_VALUE
            let matches_today = res["matches_today"] as? Int ?? UD_MATCHES_TODAY_VALUE
            if requited {
                callback(requited, match_limit, matches_today)
            }

        }
    }
    
    static func skipProfile(_ uuid: String){
        let params : Parameters = [ "likes": false ]
        post("profile/\(uuid)", parameters: params){ json in
            print(json)
        }
    }
    
    static func checkProfileSetup(callback: @escaping(_ step: Int)->Void ){
        get("self/check_setup"){ _json in
            guard let json = _json as? [String:Any] else { return }
            
            let step = json["step"] as? Int ?? 0
            callback(step)
        }
    }
    
    
    static func myself(_ callback: @escaping(_ profile: Profile)->Void){
        do {
            let cachedProfile = try profileCache.object(forKey: "myself")
            callback(cachedProfile)
        } catch {
            get("self/profile", isJob: true){ json in
                guard let pro = json as? [String: Any] else {
                    return
                }
                let profile = Profile.parseSelf(pro)
                profile.is_myself = true
                try? profileCache.setObject(profile, forKey: "myself")
                callback(profile)
            }
        }
    }
    
    
    static func updateProfile(_ body: [String: Any], callback: ((_ json: [String: Any]) -> Void)? = nil) {
        try? profileCache.removeObject(forKey: "myself")
        put("self/profile", parameters: body){ _json in
            guard let json = _json as? [String:Any] else { return }
            callback?(json)
        }
    
    }
    
    static func addKinks(_ body:[String: Any]){
        post("self/kinks", parameters: body){json in
            print(json)
        }
    }
    
    static func connections(callback: @escaping(_ profiles: [Profile])-> Void){
        get("self/connections", isJob: true){ json in

            var profiles = [Profile]()
            guard let reciprocals = json as? [Any] else {
                print("failed to cast list")
                return
            }
            
            for r in reciprocals {
                guard let rc = r as? [String:Any] else {
                    print("can't get json object")
                    continue
                }
                guard let name = rc["name"] as? String,
                    let uuid = rc["uuid"] as? String,
                    let image_id = rc["image_id"] as? String else {
                        print("can't get profile values")
                        continue
                }
                profiles.append(Profile(uuid: uuid, name: name, picture_public_id: image_id))
                
            }
            
            callback(profiles)
            
        }
    }
    
    static func partnerRequests(callback: @escaping(_ prs: [PartnerRequest]) ->Void){
        get("self/partner_requests"){ _json in
            var prequests : [PartnerRequest] = []
            
            guard let json = _json as? [String:Any] else { return }
            
            if let list = json["partner_requests"] as? [Any] {
                for jpr in list {
                    if let req = PartnerRequest(json: (jpr as? [String:Any])!) {
                        prequests.append(req)
                    }
                }
            }
            callback(prequests)
        }
    }
    
    private static func makePartnerRequest(partnerId: String){
        let params = ["partner_uuid": partnerId]
        post("self/partner_requests", parameters: params){ json in
            print("POST self/partner_requests")
            print(json)
        }
    }
    
    static func addPartner(_ email: String, callback: @escaping(_ partnerFound: Bool)->Void){
        get("self/find_user?email=\(email)"){ _json in
            guard let json = _json as? [String:Any] else { return }
            
            if let partnerId = json["partner_uuid"] as? String {
                callback(true)
                makePartnerRequest(partnerId: partnerId)
            } else {
                callback(false)
            }
        }
    }
    
    static func replyPartnerRequest(_ request_id: Int, confirm: Bool){
        let action = confirm ? "confirm" : "deny"
        let route = "self/partner_requests/\(request_id)/\(action)"
        post(route, parameters: Parameters()){ json in
            print("POST \(route)")
            print(json)
        }
        
    }
    
    static func vouch(_ userId: String, answers: [String: Any]){
        post("self/vouch/\(userId)", parameters: answers){ json in
            print(json)
        }
    }
    
    static func messageLogin(_ nonce: String, callback: @escaping(_ identity_token: String)->Void){
        get("self/message_key/\(nonce)"){ _json in
            guard let json = _json as? [String:Any] else { return }
            
            if let token = json["identity_token"] as? String{
                callback(token)
            }
        }
    }
    
    static func partners(callback: @escaping(_ users: [Profile]) -> Void){
        get("self/partners", isJob: true){ json in

            if let resArray = json as? [Any] {
                var users: [Profile] = []
                for usr in resArray {
                    if let pj = usr as? [String:Any] {
                        guard let name = pj["name"] as? String,
                            let uuid = pj["uuid"] as? String,
                            let image_id = pj["image_id"] as? String else {
                                print("can't get profile values")
                                continue
                        }
                        users.append(Profile(uuid: uuid, name: name, picture_public_id: image_id))
                    }
                    
                }
                callback(users)
            }
            
        }
    }
    
    static func removePartner(_ uuid: String){
        delete("self/partners/\(uuid)") { json in
            print(json)
        }
    }
    
    static func invitePartner(_ partner_email: String){
        post("self/invite_partner", parameters: ["email": partner_email]){json in
            print(json)
        }
    }
    
    static func blockedUsers(_ callback: @escaping(_ profiles: [Profile])-> Void){
        get("self/blocks", isJob: true){ json in

            if let resArray = json as? [[String:Any]] {
                var users: [Profile] = []
                for e in resArray {
                    guard let name = e["name"] as? String,
                        let uuid = e["uuid"] as? String,
                        let image_id = e["image_id"] as? String else {
                            print("can't get profile values")
                            continue
                    }
                    users.append(Profile(uuid: uuid, name: name, picture_public_id: image_id))
                }
                callback(users)
            }
        }
    }
    
    static func blockUser(_ uuid: String){
        post("self/block/\(uuid)", parameters: [:]) { json in
            print(json)
        }
    }
    
    static func unblockUser(_ uuid: String){
        delete("self/block/\(uuid)") { json in
            print(json)
        }
    }
    
    static func dailyLimits(_ callback: @escaping(_ limit: Int, _ matchesToday: Int) -> Void){
        get("self/daily/limits"){ _json in
            guard let json = _json as? [String:Any] else { return }
            
            if let matchLimit = json["match_limit"] as? Int,
            let matchesToday = json["matches_today"] as? Int {
                print("VEX self/daily/limits -> \(matchesToday)/\(matchLimit)")
               callback(matchLimit, matchesToday)
            }
        }
    }
    
    static func dailyMatches(callback: @escaping(_ profiles: [Profile])-> Void) {
        get("self/daily/matches"){ _json in
            guard let json = _json as? [String:Any] else { return }
            
            var profiles = [Profile]()
            guard let reciprocals = json["matches"] as? [Any] else {
                print("failed to cast list")
                return
            }
            
            for r in reciprocals {
                guard let rc = r as? [String:Any] else {
                    print("can't get json object")
                    continue
                }
                guard let name = rc["name"] as? String,
                    let uuid = rc["uuid"] as? String,
                    let image_id = rc["image_id"] as? String else {
                        print("can't get profile values")
                        continue
                }
                profiles.append(Profile(uuid: uuid, name: name, picture_public_id: image_id))
                
            }
            
            callback(profiles)
        }
    }
    
    static func loadProps(props: [String], callback: @escaping(_ json: [String:Any]) -> Void) {
        get("self/load?props=\(props.joined(separator: ","))"){ _json in
            guard let json = _json as? [String:Any] else { return }
            
            callback(json)
        }
    }
    
    
}
