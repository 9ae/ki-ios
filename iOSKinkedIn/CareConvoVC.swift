//
//  CareConvoVC.swift
//  iOSKinkedIn
//
//  Created by alice on 5/13/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import Atlas

class CareConvoVC: ATLConversationViewController, ATLConversationViewControllerDataSource {
    
    private var dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        print("client ready \(LayerHelper.client != nil)")
        do {
            self.layerClient = LayerHelper.client!
            self.conversation = try LayerHelper.startConvo(withUser: "aftercare")
            print("set conversation \(self.conversation)")
        } catch {
            print("failed to start aftercare convo")
        }
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        self.displaysAddressBar = false
        
        self.navigationItem.title = "Aftercare"
        /*
        let backItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.plain, target: nil, action: #selector(self.returnToApp))
        self.navigationItem.setLeftBarButton(backItem, animated: false)
        */
        self.dataSource = self
        
        self.messageInputToolbar.displaysRightAccessoryImage = false
        self.messageInputToolbar.leftAccessoryButton = nil
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    private func returnToApp(_ sender: Any?){
        print("return to app")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
