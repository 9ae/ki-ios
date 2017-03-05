//
//  SetupBasicVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class SetupBasicVC: SetupViewVC {
    
    @IBOutlet var fieldName: UITextField?
    @IBOutlet var fieldBirthday: UIDatePicker?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let today = Date()
        var dc = DateComponents()
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        dc.year = -18
        fieldBirthday?.maximumDate = calendar.date(byAdding: dc, to: today)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        var params = self.requestParams
        params["name"] = fieldName?.text
        
        if let birthday = fieldBirthday?.date, let calendar = fieldBirthday?.calendar {
            params["birthday"] = [
                "year": calendar.component(.year, from: birthday),
                "month": calendar.component(.month, from: birthday),
                "date": calendar.component(.day, from: birthday)
            ]
        }

        KinkedInAPI.updateProfile(params)

    }
    
}
