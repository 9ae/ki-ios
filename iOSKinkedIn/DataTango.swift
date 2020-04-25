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
    
    static let CK_GENDERS = "CK_GENDERS"
    static let CK_ROLES = "CK_ROLES"
    
    static let CK_ACT_KINKS = "CK_ACT_KINKS"
    static let CK_SERVICE_KINKS = "CK_SERVICE_KINKS"
    static let CK_OMAKE_KINKS = "CK_OMAKE_KINKS"
    
    private var profileCache : Storage<Profile>
    private var aftercareCache : Storage<CareQuestion>
    private var prolistCache : Storage<[Profile]>
    private var kinksCache : Storage<[Kink]>
    private var labelsCache : Storage<[String]>
    
    init(){
        let ds = try! Storage(
            diskConfig: DiskConfig(name: "KiCache"),
            memoryConfig: MemoryConfig(),
            transformer: TransformerFactory.forData()
        )
        self.profileCache = ds.transformCodable(ofType: Profile.self)
        self.aftercareCache = ds.transformCodable(ofType: CareQuestion.self)
        self.prolistCache = ds.transformCodable(ofType: [Profile].self)
        self.kinksCache = ds.transformCodable(ofType: [Kink].self)
        self.labelsCache = ds.transformCodable(ofType: [String].self)
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
    
    func setGenders(_ genders : [String]){
        try? labelsCache.setObject(genders, forKey: CacheLayer.CK_GENDERS)
    }
    
    func getGenders() -> [String]? {
        do {
            return try labelsCache.object(forKey: CacheLayer.CK_GENDERS)
        } catch {return nil}
    }
    
    func setRoles(_ roles: [String]){
        try? labelsCache.setObject(roles, forKey: CacheLayer.CK_ROLES)
    }
    
    func getRoles() -> [String]? {
        do {
            return try labelsCache.object(forKey: CacheLayer.CK_ROLES)
        } catch {return nil}
    }
    
    func getKinks(form : KinkForm) -> [Kink]? {
        let key = form == .act ? CacheLayer.CK_ACT_KINKS : (form == .service ? CacheLayer.CK_SERVICE_KINKS : CacheLayer.CK_OMAKE_KINKS )
        do {
            return try kinksCache.object(forKey: key)
        } catch {return nil}
    }
    
    func setKinks(form : KinkForm, kinks : [Kink]) {
        let key = form == .act ? CacheLayer.CK_ACT_KINKS : (form == .service ? CacheLayer.CK_SERVICE_KINKS : CacheLayer.CK_OMAKE_KINKS )
        try? kinksCache.setObject(kinks, forKey: key)
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
        
        if dm.hasDiscoverProfiles {
            callback(envObj)
        } else if let cached = cache.getDiscoverProfiles() {
                callback(cached)
                dm.discoverProfiles = cached
                dm.hasDiscoverProfiles = true
        } else {
            KinkedInAPI.listProfiles { api in
                callback(api)
                cache.setDiscoverProfiles(api)
                dm.discoverProfiles = api
                dm.hasDiscoverProfiles = true
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
    
    static func likeProfile(_ uuid: String){
        KinkedInAPI.likeProfile(uuid) { reciprocal,limit,matches in
            if let p = dm.discoverProfiles.firstIndex { p in p.uuid == uuid } {
                let profile = dm.discoverProfiles[p]
                
                if reciprocal {
                    addConnection(profile)
                    dm.dailyMatches.append(profile)
                }
                
                dm.discoverProfiles.remove(at: p)
            }
        }
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
    
    static func updateProfile(_ body: [String: Any], newProfile : Profile? = nil){
        KinkedInAPI.updateProfile(body)
        
        if let profile = newProfile {
            dm.allProfiles[myCacheKey] = profile
            cache.setProfile(profile, uuid: myCacheKey)
        } else {
            if let profile = dm.allProfiles[myCacheKey] {
                if let bio = body["bio"] as? String {
                    profile.bio = bio
                }
                
                if let genders = body["genders"] as? [String] {
                    profile.genders = genders
                }
                
                if let roles = body["roles"] as? [String] {
                    profile.roles = roles
                }
                dm.allProfiles[myCacheKey] = profile
                cache.setProfile(profile, uuid: myCacheKey)
            }
        }
    }
    
    static func checkProfileSetup(callback: @escaping(_ step: Int)->Void ){
        KinkedInAPI.checkProfileSetup(callback: callback)
    }
    
    /* Connections */
    
    static func connections(callback: @escaping(_ profiles: [Profile])-> Void){
        let envObj = dm.connections
        
        if dm.hasConnections {
            callback(envObj)
        } else if let cached = cache.getConnections() {
            callback(cached)
            dm.connections = cached
            dm.hasConnections = true
        } else {
            KinkedInAPI.connections { api in
                callback(api)
                cache.setConnections(api)
                dm.connections = api
                dm.hasConnections = true
            }
        }
    }
    
    private static func rmConnection(_ uuid : String) {
        dm.connections.removeAll { p in p.uuid == uuid }
        if var conns = cache.getConnections() {
            conns.removeAll { p in p.uuid == uuid }
            cache.setConnections(conns)
        }
    }
    
    private static func addConnection(_ profile : Profile) {
        dm.connections.append(profile)
        if var conns = cache.getConnections() {
            conns.append(profile)
            cache.setConnections(conns)
        }
    }
    
    static func dailyMatches(callback: @escaping(_ profiles: [Profile])-> Void) {
        let envObj = dm.dailyMatches
        
        if dm.hasDailyMatches {
            callback(envObj)
        } else {
            KinkedInAPI.dailyMatches { api in
                callback(api)
                dm.dailyMatches = api
                dm.hasDailyMatches = true
            }
        }
        
    }
    
    /* Partners */
    
    static func partners(callback: @escaping(_ profiles: [Profile])-> Void){
        let envObj = dm.partners
        if dm.hasPartners {
            callback(envObj)
        } else if let cached = cache.getPartners() {
            callback(cached)
            dm.partners = cached
            dm.hasPartners = true
        } else {
            KinkedInAPI.partners { api in
                callback(api)
                cache.setPartners(api)
                dm.partners = api
                dm.hasPartners = true
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
        if dm.hasBlockedProfiles {
            callback(envObj)
        } else if let cached = cache.getBlocked() {
            callback(cached)
            dm.blockedProfiles = cached
            dm.hasBlockedProfiles = true
        } else {
            KinkedInAPI.blockedUsers { api in
                callback(api)
                cache.setBlocked(api)
                dm.blockedProfiles = api
                dm.hasBlockedProfiles = true
            }
        }
    }
    
    private static func addBlockedProfiles(_ profile: Profile) {
        if dm.hasBlockedProfiles {
            dm.blockedProfiles.append(profile)
        }
        
        if var blocked = cache.getBlocked() {
            blocked.append(profile)
            cache.setBlocked(blocked)
        }
    }
    
    private static func rmBlockedProfiles(_ uuid : String){
        if dm.hasBlockedProfiles {
            dm.blockedProfiles.removeAll{p in p.uuid == uuid}
        }
        
        if var blocked = cache.getBlocked() {
            blocked.removeAll{p in p.uuid == uuid}
            cache.setBlocked(blocked)
        }
    }
    
    static func blockUser(_ profile: Profile){
        KinkedInAPI.blockUser(profile.uuid)
        rmConnection(profile.uuid)
        addBlockedProfiles(profile)
    }
    
    static func unblockUser(_ uuid: String){
        KinkedInAPI.blockUser(uuid)
        rmBlockedProfiles(uuid)
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
        let envObj = dm.genders
        if !envObj.isEmpty {
            callback(envObj)
        } else if let cached = cache.getGenders() {
            callback(cached)
            dm.genders = cached
        } else {
            KinkedInAPI.genders { api in
                callback(api)
                dm.genders = api
            }
        }
    }
    
    static func roles(_ callback:@escaping(_ results:[String])->Void ) {
        let envObj = dm.roles
        if !envObj.isEmpty {
            callback(envObj)
        }
        else if let cached = cache.getRoles() {
            callback(cached)
            dm.roles = cached
        }
        else {
            KinkedInAPI.roles { (api) in
                callback(api)
                dm.roles = api
            }
        }
    }
    
    static func actKinks (callback: @escaping(_ results:[Kink]) -> Void) {
        if dm.hasKinksAct {
            callback(dm.kinksAct)
        } else if let cached = cache.getKinks(form: .act) {
            callback(cached)
            dm.kinksAct = cached
        } else {
            KinkedInAPI.kinks(form: "act") { (api) in
                callback(api)
                cache.setKinks(form: .act, kinks: api)
                dm.kinksAct = api
            }
        }
    }
    
    static func serviceKinks(callback: @escaping(_ results:[Kink]) -> Void) {
        if dm.hasKinksService {
            callback(dm.kinksService)
        } else if let cached = cache.getKinks(form: .service) {
            callback(cached)
            dm.kinksService = cached
        } else {
            KinkedInAPI.kinks(form: "service") { (api) in
                callback(api)
                cache.setKinks(form: .service, kinks: api)
                dm.kinksService = api
            }
        }
    }
    
    static func omakeKinks(callback: @escaping(_ results:[Kink]) -> Void) {
        if dm.hasKinksOmake {
            callback(dm.kinksOmake)
        } else if let cached = cache.getKinks(form: .other) {
            callback(cached)
            dm.kinksOmake = cached
        } else {
            KinkedInAPI.kinks(form: "omake") { (api) in
                callback(api)
                cache.setKinks(form: .other, kinks: api)
                dm.kinksService = api
            }
        }
    }
    
    static func bioPrompts(_ callback: @escaping(_ results:[BioPrompt])->Void) {
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
