//
//  ConvoVC.swift
//  iOSKinkedIn
//
//  Created by alice on 5/12/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import Atlas
import EventKit

class ConvoVC: ATLConversationViewController, ATLConversationViewControllerDataSource {
    
    private var dateFormatter = DateFormatter()
    private let eventStore = EKEventStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        self.hidesBottomBarWhenPushed = true
        self.dataSource = self

        self.messageInputToolbar.displaysRightAccessoryImage = false
        self.messageInputToolbar.leftAccessoryButton = nil
        
        let scheduleEvent = UIBarButtonItem.init(title: "Set Date", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.onScheduleDate))
        self.navigationItem.rightBarButtonItem = scheduleEvent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkCalendarAuthorizationStatus(){
        let status = EKEventStore.authorizationStatus(for: .event)
        switch (status){
        case .notDetermined:
            requestAccessToCalendar()
        case .authorized:
            goToScheduleScreen()
        default:
            requireCalendarAccess()
        }
    }
    
    func requireCalendarAccess(){
        let alert = UIAlertController(title: "Requires Calendar Access", message:
            "For us to help you schedule dates we would need calendar acesss", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToScheduleScreen(){
        let scheduleScreen = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ScheduleDateVC") as! ScheduleDateVC
        scheduleScreen.withUserName = self.title
        self.navigationController?.pushViewController(scheduleScreen, animated: false)
    }
    
    func requestAccessToCalendar(){
        eventStore.requestAccess(to: .event) { (accessGranted, error) in
            if(accessGranted){
                DispatchQueue.main.async {
                    self.goToScheduleScreen()
                }
            } else {
                DispatchQueue.main.async {
                    self.requireCalendarAccess()
                }
            }
        }
    }
    
    func onScheduleDate(_ sender: AnyObject){
        checkCalendarAuthorizationStatus()
    }
    
    public func conversationViewController(_ conversationViewController: ATLConversationViewController, participantFor identity: LYRIdentity) -> ATLParticipant {
        return identity
    }
    
    public func conversationViewController(_ conversationViewController: ATLConversationViewController, attributedStringForDisplayOf date: Date) -> NSAttributedString {
        let dict = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.cyan
        ]
        return NSAttributedString(string: self.dateFormatter.string(from: date) , attributes: dict)
    }
    
    public func conversationViewController(_ conversationViewController: ATLConversationViewController, attributedStringForDisplayOfRecipientStatus recipientStatus: [AnyHashable : Any]) -> NSAttributedString {
        return NSAttributedString(string: "", attributes: [:])
    }
    
}
