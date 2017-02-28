//
//  ViewProfileVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/26/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class ViewProfileVC: UIViewController {
    
    @IBOutlet var profilePicture : UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
/*
        try {
            self.profilePicture?.image = UIImage(data: Data(contentsOf: URL(string: "http://www.trykinkedin.com/temp/profile_sample.jpg")!))
        }
 */
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
