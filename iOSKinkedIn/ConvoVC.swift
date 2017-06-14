//
//  ConvoVC.swift
//  iOSKinkedIn
//
//  Created by alice on 5/12/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import Atlas

class ConvoVC: ATLConversationViewController, ATLConversationViewControllerDataSource {
    
    private var dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        self.hidesBottomBarWhenPushed = true
        self.dataSource = self

        self.messageInputToolbar.displaysRightAccessoryImage = false
        self.messageInputToolbar.leftAccessoryButton = nil
        
        let scheduleEvent = UIBarButtonItem.init(image: #imageLiteral(resourceName: "calendar"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.onScheduleDate))
        let viewProfile = UIBarButtonItem.init(image: #imageLiteral(resourceName: "info"), style: .plain, target: self, action: #selector(self.onViewProfile))
        self.navigationItem.setRightBarButtonItems([viewProfile, scheduleEvent], animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func goToScheduleScreen(){
        let scheduleScreen = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ScheduleDateVC") as! ScheduleDateVC
        scheduleScreen.withUserName = self.title
        self.navigationController?.pushViewController(scheduleScreen, animated: false)
    }
    
    func onViewProfile(_ sender: AnyObject){
        
    }
    
    func onScheduleDate(_ sender: AnyObject){
        goToScheduleScreen()
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
