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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventLabel.text = "Meet \(withUser!.name)"
        
        KinkedInAPI.checkPhoneNo { isPhoneNoFound in
            self.phoneGroup.isHidden = isPhoneNoFound
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

    func registerNotification(_ date: Date){
        let dateComp = datePicker.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
        //UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "KinkedIn Aftercare"
        content.body = "How was are you feeling about your date with \(withUser!.name)?"
        content.sound = .default()
        content.categoryIdentifier = NOTECAT_AFTERCARE
        content.userInfo = [
            "meeting_dt": date,
            "with_user_id": withUser!.neoId
        ]
        
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
        
        if let phoneNumber = phoneField.text {
            print("RRR updating profile's phone number field")
            if !ScheduleDateVC.isPhoneNoValid(phoneNumber) {
                phoneInvalid.isHidden = false
                return
            }
            KinkedInAPI.updateProfile(["phone": phoneNumber])
        }
        
        let defaults = UserDefaults.standard
        var checkinHours = defaults.integer(forKey: UD_CHECKIN_TIME)
        if(checkinHours==0){
            checkinHours = UD_CHECKIN_TIME_VALUE
        }
        
        if(checkinOption.isOn){
            // 3600*checkinHours
            let date = datePicker.date.addingTimeInterval(TimeInterval(30))
            registerNotification(date)
        }
    }
    
    static func isPhoneNoValid(_ text: String) -> Bool {
        //TODO validate phone number
        return false
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
