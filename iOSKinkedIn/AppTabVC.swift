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
        KinkedInAPI.checkProfileSetup(){ step in
            if(step == 0){
                self.selectedIndex = 1
                if let changeVC = self.selectedViewController as? StaticMasterVC {
                    changeVC.toSetupProfile()
                }
            } else {
                self.selectedIndex = 1
            }
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
