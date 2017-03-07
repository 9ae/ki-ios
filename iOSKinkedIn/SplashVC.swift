//
//  SplashVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/17/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {


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
            KinkedInAPI.setToken(token)
        //    KinkedInAPI.checkProfileSetup(){ step in
            let step = 1
                if(step == 0){
                    self.performSegue(withIdentifier: "splash2setup", sender: sender)
                } else {
                    self.performSegue(withIdentifier: "splash2app", sender: sender)
                }
        //    }
        } else {
            self.performSegue(withIdentifier: "splash2register", sender: sender)
        }
    }


}
