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
    
    @Published var kinksAct : [Kink] = []
    @Published var kinksService : [Kink] = []
    @Published var kinksOmake : [Kink] = []
    
    @Published var discoverProfiles: [Profile] = []
    
    @Published var preferences : DiscoveryPreferences = DiscoveryPreferences()
    
    @Published var dailyMatches : [Profile] = []
    
    
    func markProfile(_ profile: Profile, likes: Bool) -> Void {
        self.discoverProfiles = self.discoverProfiles.filter({ pro in
            pro.uuid != profile.uuid
        })
        
        if (likes) {
            // Take out in for realz
            self.dailyMatches.append(profile)
        }
    }
}
