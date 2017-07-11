//
//  ConvoVC.swift
//  iOSKinkedIn
//
//  Created by alice on 5/12/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import Atlas

class ConvoVC: KiConvoVC {
    
    var profile: Profile?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hidesBottomBarWhenPushed = true
        
        let scheduleEvent = UIBarButtonItem(image: #imageLiteral(resourceName: "calendar"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.onScheduleDate))
        let viewProfile = UIBarButtonItem(image: #imageLiteral(resourceName: "info"), style: .plain, target: self, action: #selector(self.onViewProfile))
        self.navigationItem.setRightBarButtonItems([viewProfile, scheduleEvent], animated: false)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Chat", style: .plain, target: nil, action: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func goToScheduleScreen(){
        let scheduleScreen = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ScheduleDateVC") as! ScheduleDateVC
        scheduleScreen.withUserName = self.title
        self.navigationController?.pushViewController(scheduleScreen, animated: false)
    }
    
    func onViewProfile(_ sender: AnyObject){
        
        if let uuid = profile?.neoId {
            
            self.view.makeToastActivity(.center)
            
            KinkedInAPI.readProfile(uuid) { profile in
                let profileView = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "discoverProfileVC") as! DiscoverProfile
                profileView.setProfile(profile, isDiscoverMode: false)
                self.view.hideToastActivity()
                self.navigationController?.pushViewController(profileView, animated: false)
            }
        
        }
        
    }
    
    func onScheduleDate(_ sender: AnyObject){
        goToScheduleScreen()
    }
    
}
