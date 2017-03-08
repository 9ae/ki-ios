//
//  SetupBioVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/19/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class SetupBioVC: SetupViewVC {

    @IBOutlet weak var bioField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func completeSetup(_ sender: AnyObject){
        let params: [String:Any] = [
            "setup_complete" : true,
            "bio" : bioField?.text ?? ""
            ]
        KinkedInAPI.updateProfile(params)
        
        NotificationCenter.default.post(name: NOTIFY_PROFILE_SETUP_COMPLETE, object: nil)
    }

}
