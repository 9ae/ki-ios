//
//  BasicVC.swift
//  iOSKinkedIn
//
//  Created by alice on 6/18/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class BasicVC: UIViewController {
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var birthdayField: UIDatePicker!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let today = Date()
        var dc = DateComponents()
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        dc.year = -18
        birthdayField?.maximumDate = calendar.date(byAdding: dc, to: today)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func values() -> [String: Any] {
        var params = [String:Any]()
        
        if let name = nameField?.text {
            params["name"] = name
        }
        
        if let birthday = birthdayField?.date, let calendar = birthdayField?.calendar {
            params["birthday"] = [
                "year": calendar.component(.year, from: birthday),
                "month": calendar.component(.month, from: birthday),
                "date": calendar.component(.day, from: birthday)
            ]
        }
        return params
    }
    
    func hasName() -> Bool {
        return nameField?.text != nil
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
