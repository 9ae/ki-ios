//
//  SetupPageNC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class SetupPageNC: UINavigationController {
    
    var token: String?

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (token != nil){
        
            NotificationCenter.default.addObserver(self,
                selector: #selector(SetupPageNC.handleProfileSetupComplete),
                name: NOTIFY_PROFILE_SETUP_COMPLETE, object: nil)
        
            let firstScreen = self.viewControllers.first as? SetupViewVC
            firstScreen?.setToken(token!)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleProfileSetupComplete(){
        self.performSegue(withIdentifier: "setup2app", sender: self)
    }

}
