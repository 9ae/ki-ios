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
    
    @Published var allProfiles : [String:Profile] = [:]
    @Published var discoverProfiles: [Profile] = [] // TODO opt
    @Published var preferences : DiscoveryPreferences = DiscoveryPreferences()
    @Published var dailyMatches : [Profile] = [] // TODO opt
    @Published var connections: [Profile] = [] // TODO opt
    @Published var partners : [Profile] = [] // TODO opt
    @Published var blockedProfiles : [Profile] = [] // TODO opt
    
    @Published var myPhoneNumber : String?
    
    func myProfile() -> Profile? {
        return self.allProfiles["myself"]
    }
    
    func markProfile(_ profile: Profile, likes: Bool) -> Void {
        self.discoverProfiles = self.discoverProfiles.filter({ pro in
            pro.uuid != profile.uuid
        })
        
        if (likes) {
            // Take out in for realz
            self.dailyMatches.append(profile)
        }
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
