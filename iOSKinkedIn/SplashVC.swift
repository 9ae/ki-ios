//
//  SplashVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/17/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    @IBOutlet weak var iConsent: UIButton!
    var waitForReadyTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        KinkedInAPI.test { ok in
            if(ok){
                self.allowGo()
            } else {
                print("Server is down")
                /*
                self.waitForReadyTimer = Timer.scheduledTimer(timeInterval: 3,
                                                              target: self,
                                                              selector: #selector(self.pingServer),
                                                              userInfo: nil, repeats: true);
                */
            }
        }
        
        allowGo()
    }
    
    func allowGo(){
        self.iConsent.isEnabled = true
        UIView.animate(withDuration: 1){
            self.iConsent.alpha = 1.0
        }
    }

    func pingServer(){
        KinkedInAPI.test{ ok in
            if(ok){
                print("server up")
                self.waitForReadyTimer?.invalidate()
                self.allowGo()
            } else {
                print("server down... waiting 3 seconds to try again")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func go(_ sender: AnyObject){
        iConsent.isEnabled = false
        UIView.animate(withDuration: 0.5){
            self.iConsent.alpha = 0.1
        }

        if let token = KeychainWrapper.standard.string(forKey: "kiToken") {
            KinkedInAPI.setToken(token)
            self.performSegue(withIdentifier: "splash2app", sender: sender)
        } else {
            self.performSegue(withIdentifier: "splash2register", sender: sender)
        }
        
    }


}
