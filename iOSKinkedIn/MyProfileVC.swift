//
//  MyProfileVC.swift
//  iOSKinkedIn
//
//  Created by alice on 1/5/19.
//  Copyright © 2019 KinkedIn. All rights reserved.
//

import UIKit

class MyProfileVC: CodeProfileVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.kinksMatched.isHidden = true
        self.vouchedBy.isHidden = true
        
        let editBasic = UIButton(type: .infoDark)
        basicInfo.addSubview(editBasic)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
