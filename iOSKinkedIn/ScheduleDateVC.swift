//
//  ScheduleDateVC.swift
//  iOSKinkedIn
//
//  Created by alice on 6/6/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import UserNotifications

class ScheduleDateVC: UIViewController {
    
    var withUserName: String?
    @IBOutlet var eventLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var checkinOption: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventLabel.text = "Meet \(withUserName)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerNotification(_ trigger: UNCalendarNotificationTrigger){
        let content = UNMutableNotificationContent()
        content.title = "KinkedIn Aftercare"
        content.body = "How was are you feeliong about your date with \(withUserName)?"
        content.sound = .default()
        
        let request = UNNotificationRequest(identifier: "KiAftercareCheck", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                print("we will checkin with you after then")
            }
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    @IBAction func onSaveDate(_ sender: AnyObject){
        if(checkinOption.isOn){
            let date = datePicker.date.addingTimeInterval(15) // in sections
            let dateComp = datePicker.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
            registerNotification(trigger)
        }
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
