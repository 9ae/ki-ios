//
//  CProfile.swift
//  iOSKinkedIn
//
//  Created by alice on 3/12/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class CProfile: UIViewController {
    
    var profile: Profile?
    var profileView: ViewProfileVC?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = profile?.name
        self.navigationItem.title = self.title
        KinkedInAPI.readProfile((profile?.neoId)!, callback: self.setProfile)
        // Do any additional setup after loading the view.
    }
    
    func setProfile(profile: Profile){
        self.profile = profile
        profileView?.setProfile(profile)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "connectProfile"){
            profileView = segue.destination as? ViewProfileVC
            profileView?.enableActions(false)
            profileView?.isReadOnly = true
        }
    }
    

}
