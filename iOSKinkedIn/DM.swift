import Foundation

class DiscoveryPreferences : ObservableObject {
    @Published var minAge : String = ""
    @Published var maxAge : String = ""
    
    @Published var genders : [String] = []
    @Published var roles : [String] = []
}

// This it the global model manager
class DM : ObservableObject {
    @Published var genders: [String] = []
    @Published var roles: [String] = []
    
    @Published var discoverProfiles: [Profile] = []
    
    @Published var preferences : DiscoveryPreferences = DiscoveryPreferences()
    
    @Published var dailyMatches : [Profile] = []
    
    func markProfile(_ uuid: String) -> Void {
        self.discoverProfiles = self.discoverProfiles.filter({ pro in
            pro.uuid != uuid
        })
    }
}
