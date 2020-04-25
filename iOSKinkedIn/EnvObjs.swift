//
//  EnvObjs.swift
//  iOSKinkedIn
//
//  Created by Alice on 3/7/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import Foundation

class DiscoveryPreferences : ObservableObject {
    @Published var minAge : String = ""
    @Published var maxAge : String = ""
    
    @Published var genders : [String] = []
    @Published var roles : [String] = []
    
    func setGender(label: String, add: Bool) -> Void {
        if(add){
            self.genders.append(label)
        } else {
            self.genders = self.genders.filter({ gender in gender != label})
        }
    }
    
    func setRole(label: String, add: Bool) -> Void {
        if(add){
            self.roles.append(label)
        } else {
            self.roles = self.roles.filter({ role in role != label})
        }
    }
}

// This it the global model manager
final class Dungeon : ObservableObject {
    static let shared = Dungeon()
    
    @Published var genders: [String] = []
    @Published var roles: [String] = []
    @Published var bioPrompts : [BioPrompt] = []
    @Published var cities : [City] = []
    @Published var expLevels : [String] = []
    
    @Published var kinksAct : [Kink] = []
    @Published var kinksService : [Kink] = []
    @Published var kinksOmake : [Kink] = []
    
    @Published var hasKinksAct : Bool = false
    @Published var hasKinksService : Bool = false
    @Published var hasKinksOmake : Bool = false
    
    @Published var allProfiles : [String:Profile] = [:]
    @Published var discoverProfiles: [Profile] = []
    @Published var hasDiscoverProfiles : Bool = false
    @Published var preferences : DiscoveryPreferences = DiscoveryPreferences()
    @Published var dailyMatches : [Profile] = []
    @Published var hasDailyMatches : Bool = false
    @Published var connections: [Profile] = []
    @Published var hasConnections : Bool = false
    @Published var partners : [Profile] = []
    @Published var hasPartners : Bool = false
    @Published var blockedProfiles : [Profile] = []
    @Published var hasBlockedProfiles : Bool = false
    
    @Published var myPhoneNumber : String?
    
    func myProfile() -> Profile? {
        return self.allProfiles["myself"]
    }
    
    func updateMyProfileWithKink(_ kink: Kink) -> Void {
        guard let profile = self.allProfiles["myself"] else {
            return
        }
        
        let kinks = profile.kinks
        
        if let index = kinks.firstIndex(where: { k in
            k.code == kink.code
        }) {
            profile.kinks.remove(at: index)
            profile.kinks.append(kink)
        } else {
            profile.kinks.append(kink)
        }
        self.allProfiles["myself"] = profile
    }
}
