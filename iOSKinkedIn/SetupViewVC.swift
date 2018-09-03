//
//  SetupViewVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/17/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class SetupViewVC: UIViewController {
    
    func alert(_ msg: String, title: String){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated:false)
    }
    
}
