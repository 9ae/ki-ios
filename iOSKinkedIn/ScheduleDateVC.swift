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
    
    var withUser: Profile?

    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var checkinOption: UISwitch!
    
    @IBOutlet var hoursField: UITextField!
    
    private var isPhoneValid: Bool = true
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.titleView?.backgroundColor = ThemeColors.primaryDark
        self.navigationItem.titleView?.tintColor = UIColor.white
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func registerNotification(_ date: Date, content: UNMutableNotificationContent){
        let dateComp = datePicker.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)

        let id = "KinkedIn \(date.description)"
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if error != nil {
                print(error?.localizedDescription)
            }
        }
    }
    
    func scheduleCheckin(_ date: Date){
        var checkinHours = Int(hoursField?.text ?? "0") ?? UserDefaults.standard.integer(forKey: UD_CHECKIN_TIME)
        
        if checkinHours == 0 {
            checkinHours = UD_CHECKIN_TIME_VALUE
        }
        
        let scheduleDT = date.addingTimeInterval(TimeInterval(3600*checkinHours))
        let content = UNMutableNotificationContent()
        content.title = "KinkedIn Aftercare"
        content.body = "How was are you feeling about your date with \(withUser!.name)?"
        content.sound = .default
        content.categoryIdentifier = NOTECAT_AFTERCARE
        content.userInfo = [
            "meeting_dt": date,
            "with_user_id": withUser!.uuid
        ]
        registerNotification(scheduleDT, content: content)
    }
    
    func scheduleDateReminder(_ date: Date){
        let scheduleDT = date.addingTimeInterval(TimeInterval(-7200))
        let content = UNMutableNotificationContent()
        content.title = "You've got a date!"
        content.body = "You are meeting with \(withUser!.name) in 2 hours."
        content.sound = .default
        content.categoryIdentifier = NOTECAT_DATE_REMINDER
        registerNotification(scheduleDT, content: content)
    }
    
    @IBAction func onSaveDate(_ sender: AnyObject){
        if(checkinOption.isOn){
            scheduleCheckin(datePicker.date)
            //TODO get checkin time
        }
        scheduleDateReminder(datePicker.date)
        self.navigationController?.popViewController(animated: false)
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
