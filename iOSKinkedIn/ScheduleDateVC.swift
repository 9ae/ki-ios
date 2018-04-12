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
    @IBOutlet var eventLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var checkinOption: UISwitch!
    
    @IBOutlet var phoneGroup: UIStackView!
    @IBOutlet var phoneField: UITextField!
    @IBOutlet var phoneInvalid: UILabel!
    
    private var isPhoneValid: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventLabel.text = "Meet \(withUser!.name)"
        
        KinkedInAPI.checkPhoneNo { isPhoneNoFound in
            self.phoneGroup.isHidden = isPhoneNoFound
            if (!isPhoneNoFound){
                self.phoneField.placeholder = "xxx-xxx-xxxx"
                self.isPhoneValid = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPhoneInfo(_ sender: Any) {
        let phoneInfoAlert = UIAlertController(
            title: "Why we need your phone number?",
            message: "Just in case you will want a free counselling session from our Aftercare counsellors, we would like a way to reach you.",
            preferredStyle: .alert)
        phoneInfoAlert.show(self, sender: sender)
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
        var checkinHours = UserDefaults.standard.integer(forKey: UD_CHECKIN_TIME)
        if(checkinHours==0){
            checkinHours = UD_CHECKIN_TIME_VALUE
        }
        let scheduleDT = date.addingTimeInterval(TimeInterval(3600*checkinHours))
        let content = UNMutableNotificationContent()
        content.title = "KinkedIn Aftercare"
        content.body = "How was are you feeling about your date with \(withUser!.name)?"
        content.sound = .default()
        content.categoryIdentifier = NOTECAT_AFTERCARE
        content.userInfo = [
            "meeting_dt": date,
            "with_user_id": withUser!.neoId
        ]
        registerNotification(scheduleDT, content: content)
    }
    
    func scheduleDateReminder(_ date: Date){
        let scheduleDT = date.addingTimeInterval(TimeInterval(-7200))
        let content = UNMutableNotificationContent()
        content.title = "You've got a date!"
        content.body = "You are meeting with \(withUser!.name) in 2 hours."
        content.sound = .default()
        content.categoryIdentifier = NOTECAT_DATE_REMINDER
        registerNotification(scheduleDT, content: content)
    }
    
    @IBAction func onSaveDate(_ sender: AnyObject){
        if !isPhoneValid && checkinOption.isOn {
            self.phoneInvalid.isHidden = false
            self.validatePhoneNumber()
            return
        }
        prepNotifications()
    }
    
    func prepNotifications(){
        if(checkinOption.isOn){
            scheduleCheckin(datePicker.date)
        }
        scheduleDateReminder(datePicker.date)
        self.navigationController?.popViewController(animated: false)
    }
    
    func validatePhoneNumber(isFromSave: Bool = false){
        if let phoneNumber = phoneField.text, !phoneNumber.isEmpty {
            self.view.makeToastActivity(.center)
            KinkedInAPI.updateProfile(["phone": phoneNumber], callback: { json in
                if let invalidFields = json["invalid_fields"] as? [String] {
                    if invalidFields.contains("phone") {
                        self.phoneInvalid.isHidden = false
                    } else {
                        self.isPhoneValid = true
                        if isFromSave {
                            self.prepNotifications()
                        }
                    }
                    self.view.hideToastActivity()
                }
            })
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
