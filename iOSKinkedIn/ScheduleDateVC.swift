//
//  ScheduleDateVC.swift
//  iOSKinkedIn
//
//  Created by alice on 6/6/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class ScheduleDateVC: UIViewController {
    
    var withUserName: String?
    @IBOutlet var eventLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = withUserName {
            eventLabel.text = "Meet \(name)"
        }
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
