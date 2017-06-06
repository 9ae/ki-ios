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
        
        eventLabel.text = "Meet \(withUserName!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerNotification(_ date: Date){
        let dateComp = datePicker.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
        //UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "KinkedIn Aftercare"
        content.body = "How was are you feeling about your date with \(withUserName!)?"
        content.sound = .default()
        
        let id = "KIA \(date.description)"
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if error != nil {
                print(error?.localizedDescription)
            }
        }
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func onSaveDate(_ sender: AnyObject){
        if(checkinOption.isOn){
            let date = datePicker.date.addingTimeInterval(30) // in sections
            registerNotification(date)
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
