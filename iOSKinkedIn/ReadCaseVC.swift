//
//  ReadCaseVC.swift
//  iOSKinkedIn
//
//  Created by alice on 6/28/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import Atlas

class ReadCaseVC: ATLConversationViewController,
    ATLConversationViewControllerDataSource,
    ATLConversationViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataSource = self
        self.delegate = self
        self.displaysAddressBar = false
        
        self.messageInputToolbar.isHidden = true
        self.messageInputToolbar.resignFirstResponder()
        
        if let dateTitle = self.conversation.createdAt?.description {
            self.setTitleToAll(dateTitle)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func conversationViewController(_ conversationViewController: ATLConversationViewController, participantFor identity: LYRIdentity) -> ATLParticipant {
        return identity
    }
    
    
    /**
     @abstract Asks the data source for an `NSAttributedString` representation of a given date.
     @param conversationViewController The `ATLConversationViewController` requesting the string.
     @param date The `NSDate` object to be displayed as a string.
     @return an `NSAttributedString` representing the given date.
     @discussion The date string will be displayed above message cells in section headers. The date represents the `sentAt` date of a message object.
     The string can be customized to appear in whichever format your application requires.
     */
    @available(iOS 3.2, *)
    public func conversationViewController(_ conversationViewController: ATLConversationViewController, attributedStringForDisplayOf date: Date) -> NSAttributedString {
        return NSAttributedString(string: "", attributes: [:])
    }
    
    
    /**
     @abstract Asks the data source for an `NSAttributedString` representation of a given `LYRRecipientStatus`.
     @param conversationViewController The `ATLConversationViewController` requesting the string.
     @param recipientStatus The `LYRRecipientStatus` object to be displayed as a question
     string.
     @return An `NSAttributedString` representing the give recipient status.
     @discussion The recipient status string will be displayed below message the most recent message sent by the authenticated user.
     */
    @available(iOS 3.2, *)
    public func conversationViewController(_ conversationViewController: ATLConversationViewController, attributedStringForDisplayOfRecipientStatus recipientStatus: [AnyHashable : Any]) -> NSAttributedString {
        return NSAttributedString(string: "", attributes: [:])
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
