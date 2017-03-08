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
    //var waitForReadyTimer: Timer
    
    /*
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            DispatchTime.now( dispatch_time_t(DISPATCH_TIME_NOW), Int64(delay * Double(NSEC_PER_SEC))), DispatchQueue.main, closure)
    }
    */

    override func viewDidLoad() {
        super.viewDidLoad()
        
        KinkedInAPI.test { ok in
            if(ok){
                print("server up")
            } else {
                print("server down... waiting 5 seconds to try again")
            }
            self.iConsent.isEnabled = true
            UIView.animate(withDuration: 1){
                self.iConsent.alpha = 1.0
            }
        }
        
        //waitForReadyTimer = Timer(timeInterval: 5, target: self, selector: #selector(pingServer), userInfo: nil, repeats: true)
    }
    /*
    @objc
    func pingServer(){
        KinkedInAPI.test { ok in
            if(ok){
                self.iConsent.isEnabled = true
                print("server up")
            } else {
                print("server down... waiting 5 seconds to try again")
            }
        }
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func go(_ sender: AnyObject){
        if let token = Login.getToken(){
            KinkedInAPI.setToken(token)
            KinkedInAPI.checkProfileSetup(){ step in
                if(step == 0){
                    self.performSegue(withIdentifier: "splash2setup", sender: sender)
                } else {
                    self.performSegue(withIdentifier: "splash2app", sender: sender)
                }
            }
        } else {
            self.performSegue(withIdentifier: "splash2register", sender: sender)
        }
    }


}
