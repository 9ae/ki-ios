//
//  AppTabVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/28/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class AppTabVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        DataTango.checkProfileSetup(){ step in
            if(step == 0){
                print("finish profile setup")
                self.selectedIndex = 0
            } else {
                print("connections view")
                // TODO: check if users has connections
                // go to connections, else go to discover
                self.selectedIndex = 2
            }
        } */
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
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
    }
    

}
