//
//  DiscoverVC.swift
//  iOSKinkedIn
//
//  Created by alice on 3/2/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class DiscoverVC: UIViewController {
    
    var profileViewController: ViewProfileVC?
    var profilesQueue = [String]()
    var fakeProfiles = [ViewProfile]()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(loadNextProfile), name: NOTIFY_NEXT_PROFILE, object: nil)
        /* uncomment when server is up
        KinkedInAPI.listProfiles { uuids in
            self.profilesQueue = uuids
            self._popProfile()
        }
         */
        fakeProfiles = ShadowUsers().users
        self._popProfile()
    }
    
    @objc func loadNextProfile() {
        self._popProfile()
    }
    
    private func _popProfile(){
        if(self.profileViewController == nil){
            return
        }
        print("load next profile")
        let profile = self.fakeProfiles.removeFirst()
        self.profileViewController?.setProfile(profile)
        /* uncomment when server is up
        let uuid = self.profilesQueue.removeFirst()
        KinkedInAPI.readProfile(uuid) { profile in
            self.profileViewController?.setProfile(profile)
        }
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "profileContainer"){
            self.profileViewController = segue.destination as? ViewProfileVC
        }
    }
    
}
