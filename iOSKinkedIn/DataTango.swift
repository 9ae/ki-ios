//
//  DataTango.swift
//  iOSKinkedIn
//
//  Created by Alice on 4/24/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import Foundation
import Cache


class CacheLayer {
    /* cache keys */
    static let CK_AFTERCARE_FLOW = "CH_AFTERCARE_FLOW2_"

    static let CK_DISCOVER = "CK_DISCOVER"
    static let CK_CONNECTIONS = "CK_CONNECTIONS"
    static let CK_PARTNERS = "CK_PARTNERS"
    static let CK_BLOCKED = "CK_BLOCKED"
    
    private var profileCache : Storage<Profile>
    private var aftercareCache : Storage<CareQuestion>
    private var prolistCache : Storage<[Profile]>
    
    init(){
        let ds = try! Storage(
            diskConfig: DiskConfig(name: "KiCache"),
            memoryConfig: MemoryConfig(),
            transformer: TransformerFactory.forData()
        )
        self.profileCache = ds.transformCodable(ofType: Profile.self)
        self.aftercareCache = ds.transformCodable(ofType: CareQuestion.self)
        self.prolistCache = ds.transformCodable(ofType: [Profile].self)
    }
    
    func logout() {
        try? profileCache.removeAll()
        try? prolistCache.removeAll()
    }
    
    func getDiscoverProfiles () -> [Profile]? {
        do {
            return try prolistCache.object(forKey: CacheLayer.CK_DISCOVER)
        } catch {
            return nil
        }
    }
    
    func setDiscoverProfiles(_ profiles: [Profile]){
        try? prolistCache.setObject(profiles, forKey: CacheLayer.CK_DISCOVER)
    }
    
    func getConnections () -> [Profile]? {
        do {
            return try prolistCache.object(forKey: CacheLayer.CK_CONNECTIONS)
        } catch {
            return nil
        }
    }
    
    func setConnections (_ profiles: [Profile]){
        try? prolistCache.setObject(profiles, forKey: CacheLayer.CK_CONNECTIONS)
    }
    
    func getPartners () -> [Profile]? {
        do {
            return try prolistCache.object(forKey: CacheLayer.CK_PARTNERS)
        } catch {
            return nil
        }
    }
    
    func setPartners (_ profiles : [Profile]) {
        try? prolistCache.setObject(profiles, forKey: CacheLayer.CK_PARTNERS)
    }
    
    func getBlocked () -> [Profile]? {
        do {
            return try prolistCache.object(forKey: CacheLayer.CK_BLOCKED)
        } catch { return nil}
    }
    
    func setBlocked(_ profiles: [Profile]) {
        try? prolistCache.setObject(profiles, forKey: CacheLayer.CK_BLOCKED)
    }
    
    func getProfile(_ uuid: String) -> Profile? {
        do {
            return try profileCache.object(forKey: uuid)
        } catch {
            return nil
        }
    }
    
    func setProfile(_ profile : Profile, uuid: String) {
        try? profileCache.setObject(profile, forKey: uuid)
    }
    
    func rmProfile(_ uuid: String){
        try? profileCache.removeObject(forKey: uuid)
    }
    
}

class DataTango {
    
    static let myCacheKey = "myself"
    
    static let cache = CacheLayer()
    static let dm = Dungeon()
    
    /* Auth */
    
    static func register(email: String, password: String, inviteCode: String, callback: @escaping(_ success:Bool)->Void){
        KinkedInAPI.register(email: email, password: password, inviteCode: inviteCode, callback: callback)
    }
    
    static func login(email: String, password: String, callback: @escaping(_ success: Bool)->Void){
        KinkedInAPI.login(email: email, password: password, callback: callback)
    }
    
    static func logout(){
        KinkedInAPI.logout()
        cache.logout()
    }
    
    static func setToken(_ token: String){
        KinkedInAPI.setToken(token)
    }
    
    /* Discovery */
    
    static func discoverProfiles(callback: @escaping(_ profiles: [Profile])->Void) {
        let envObj = dm.discoverProfiles
        
        if !envObj.isEmpty {
            callback(envObj)
        } else if let cached = cache.getDiscoverProfiles() {
                callback(cached)
                dm.discoverProfiles = cached
        } else {
            KinkedInAPI.listProfiles { api in
                callback(api)
                cache.setDiscoverProfiles(api)
                dm.discoverProfiles = api
            }
        }
    }
    
    static func readProfile(_ uuid: String, callback: @escaping(_ profile: Profile)->Void) {
        if let envObj = dm.allProfiles[uuid] {
            callback(envObj)
        } else if let cached = cache.getProfile(uuid) {
            callback(cached)
            dm.allProfiles[uuid] = cached
        } else {
            KinkedInAPI.readProfile(uuid) { api in
                callback(api)
                cache.setProfile(api, uuid: uuid)
                dm.allProfiles[uuid] = api
            }
        }
    }
    
    static func likeProfile(_ uuid: String, callback: @escaping(_ reciprocal: Bool,
        _ match_limit: Int, _ matches_today: Int)->Void ){
        KinkedInAPI.likeProfile(uuid, callback: callback)
        // TODO rm discovery list
        // TODO add to connections list
    }
    
    /* My Profile */
    
    static func myself(_ callback: @escaping(_ profile: Profile)->Void){
        if let envObj = dm.allProfiles[myCacheKey] {
            callback(envObj)
        } else if let cached = cache.getProfile(myCacheKey) {
            callback(cached)
            dm.allProfiles[myCacheKey] = cached
        } else {
            KinkedInAPI.myself { api in
                callback(api)
                cache.setProfile(api, uuid: myCacheKey)
                dm.allProfiles[myCacheKey] = api
            }
        }
    }
    
    static func updateProfile(_ body: [String: Any]){
        KinkedInAPI.updateProfile(body)
        dm.allProfiles.removeValue(forKey: myCacheKey)
        cache.rmProfile(myCacheKey)
        // TODO update both stores with only updated keys
    }
    
    static func checkProfileSetup(callback: @escaping(_ step: Int)->Void ){
        KinkedInAPI.checkProfileSetup(callback: callback)
    }
    
    /* Connections */
    
    static func connections(callback: @escaping(_ profiles: [Profile])-> Void){
        let envObj = dm.connections
        
        if !envObj.isEmpty {
            callback(envObj)
        } else if let cached = cache.getConnections() {
            callback(cached)
            dm.connections = cached
        } else {
            KinkedInAPI.connections { api in
                callback(api)
                cache.setConnections(api)
                dm.connections = api
            }
        }
    }
    
    static func dailyMatches(callback: @escaping(_ profiles: [Profile])-> Void) {
        KinkedInAPI.dailyMatches(callback: callback)
    }
    
    /* Partners */
    
    static func partners(callback: @escaping(_ profiles: [Profile])-> Void){
        let envObj = dm.partners
        if !envObj.isEmpty {
            callback(envObj)
        } else if let cached = cache.getPartners() {
            callback(cached)
            dm.partners = cached
        } else {
            KinkedInAPI.partners { api in
                callback(api)
                cache.setPartners(api)
                dm.partners = api
            }
        }
    }
    
    static func addPartner(_ email: String, callback: @escaping(_ partnerFound: Bool)->Void){
        KinkedInAPI.addPartner(email, callback: callback)
    }
    
    static func invitePartner(_ partner_email: String){
        KinkedInAPI.invitePartner(partner_email)
    }
    
    static func unPartner(_ uuid: String){
        KinkedInAPI.unPartner(uuid)
    }
    
    static func partnerRequests(callback: @escaping(_ prs: [PartnerRequest]) ->Void){
        KinkedInAPI.partnerRequests(callback: callback)
    }
    
    static func replyPartnerRequest(_ request_id: Int, confirm: Bool){
        KinkedInAPI.replyPartnerRequest(request_id, confirm: confirm)
    }
    
    /* Blocked Relationship */
    
    static func blockedProfiles (callback: @escaping(_ profiles: [Profile])-> Void){
        let envObj = dm.blockedProfiles
        if !envObj.isEmpty {
            callback(envObj)
        } else if let cached = cache.getBlocked() {
            callback(cached)
            dm.blockedProfiles = cached
        } else {
            KinkedInAPI.blockedUsers { api in
                callback(api)
                cache.setBlocked(api)
                dm.blockedProfiles = api
            }
        }
    }
    
    static func blockUser(_ uuid: String){
        KinkedInAPI.blockUser(uuid)
        // TODO update connection & block cache
    }
    
    static func unblockUser(_ uuid: String){
        KinkedInAPI.blockUser(uuid)
        // TODO update block cache
    }
    
    static func myPhoneNumber(callback: @escaping(_ phone: String) -> Void){
        if let phone = dm.myPhoneNumber {
            callback(phone)
        } else {
            KinkedInAPI.loadProps(props: ["phone"]) { json in
                if let apiPhone = json["phone"] as? String {
                    callback(apiPhone)
                } else {
                    print("can't find phone number in proms")
                }
            }
        }
    }
    
    static func updateMyPhoneNumber(_ phone: String) {
        dm.myPhoneNumber = phone
        KinkedInAPI.updateProfile(["phone": phone])
    }
    
    /* Aftercare */
    
    static func aftercareFlow(caseType: CaseType, callback : @escaping (_ flow: CareQuestion) -> Void) {
        KinkedInAPI.aftercareFlow(caseType: caseType, callback: callback)
    }
    
    static func aftercareCases(callback : @escaping(_ cases: [Case]) -> Void ){
        KinkedInAPI.aftercareCases(callback: callback)
    }
    
    static func createCase(aboutUser: String, caseType: CaseType, callback : @escaping (_ case_id : Int) -> Void){
        KinkedInAPI.createCase(aboutUser: aboutUser, caseType: caseType, callback: callback)
    }
    
    static func alertCATeam(case_id: Int){
        KinkedInAPI.alertCATeam(case_id: case_id)
    }
    
    static func writeToCaselog(case_id: Int, msg: Message, date: Date?){
        KinkedInAPI.writeToCaselog(case_id: case_id, msg: msg, date: date)
    }
    
    static func vouch(_ userId: String, answers: [String: Any]){
        KinkedInAPI.vouch(userId, answers: answers)
    }
    
    /* Public Endpoints */
    
    static func genders(_ callback:@escaping(_ results:[String])->Void ) {
        // TODO we can cache this
        let envObj = dm.genders
        if !envObj.isEmpty {
            callback(envObj)
        } else {
            KinkedInAPI.genders { api in
                callback(api)
                dm.genders = api
            }
        }
    }
    
    static func roles(_ callback:@escaping(_ results:[String])->Void ) {
        // TODO we can cache this
        let envObj = dm.roles
        if !envObj.isEmpty {
            callback(envObj)
        } else {
            KinkedInAPI.roles { (api) in
                callback(api)
                dm.roles = api
            }
        }
    }
    
//    static func kinks(form: String, callback: @escaping(_ results:[Kink]) -> Void) {
//        // TODO we should definitely cache this
//        let envObj = (form == KinkForm.service) ?? (dm.kinksService) : (form == KinkForm.act ?? dm.kinks : )
//    }
    
    static func bioPrompts(_ callback: @escaping(_ results:[BioPrompt])->Void) {
        // TODO we can cache this
        let envObj = dm.bioPrompts
        if !envObj.isEmpty {
            callback(envObj)
        } else {
            KinkedInAPI.bioPrompts { api in
                callback(api)
                dm.bioPrompts = api
            }
        }
    }
    
    static func experienceLevels(_ callback:@escaping(_ results:[String])->Void) {
        // TODO we can cache this
        let envObj = dm.expLevels
        if !envObj.isEmpty {
            callback(envObj)
        } else {
            KinkedInAPI.experienceLevels { api in
                callback(api)
                dm.expLevels = api
            }
        }
    }
    
    static func cities(_ callback:@escaping(_ results:[City])->Void) {
        // TODO we can cache this
        let envObj = dm.cities
        
        if !envObj.isEmpty {
            callback(envObj)
        } else {
            KinkedInAPI.cities{ api in
                callback(api)
                dm.cities = api
            }
        }
    }
    
}
