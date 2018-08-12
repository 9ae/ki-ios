//
//  KiConvoVC.swift
//  iOSKinkedIn
//
//  Created by Alice Q Wong on 7/10/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class KiConvoVC: ATLConversationViewController, ATLConversationViewControllerDataSource {

    private var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        self.displaysAddressBar = false
        self.messageInputToolbar.displaysRightAccessoryImage = false
        self.messageInputToolbar.leftAccessoryButton = nil

        ATLIncomingMessageCollectionViewCell.appearance().bubbleViewColor = ThemeColors.msgIn
        ATLIncomingMessageCollectionViewCell.appearance().messageTextColor = UIColor.white
        
        ATLOutgoingMessageCollectionViewCell.appearance().bubbleViewColor = ThemeColors.msgOut
        ATLOutgoingMessageCollectionViewCell.appearance().messageTextColor = UIColor.white

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    public func conversationViewController(_ conversationViewController: ATLConversationViewController, participantFor identity: LYRIdentity) -> ATLParticipant {
        return identity
    }
    
    public func conversationViewController(_ conversationViewController: ATLConversationViewController, attributedStringForDisplayOf date: Date) -> NSAttributedString {
        let dict = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: ThemeColors.primaryFade
        ]
        return NSAttributedString(string: self.dateFormatter.string(from: date) , attributes: dict)
    }
    
    public func conversationViewController(_ conversationViewController: ATLConversationViewController, attributedStringForDisplayOfRecipientStatus recipientStatus: [AnyHashable : Any]) -> NSAttributedString {
        return NSAttributedString(string: "", attributes: [:])
    }

}
