//
//  SplashVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/17/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {
    
    var userNeoId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func go(_ sender: AnyObject){
        if let token = Login.getToken(){
            KinkedInAPI.validate(token, callback: { (_ neoId) -> Void in
                self.userNeoId = neoId
                if ((Profile.get(neoId)) != nil){
                    print("START: go to app")
                    self.performSegue(withIdentifier: "splash2app", sender: sender)
                } else {
                    print("START: profile setup")
                    self.performSegue(withIdentifier: "splash2setup", sender: sender)
                }
            })
        } else {
            print("START: login screen")
            self.performSegue(withIdentifier: "splash2register", sender: sender)
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier=="splash2setup"){
            let setupView = segue.destination as? SetupPageNC
            setupView?.userNeoId = userNeoId
        }
    }

}
