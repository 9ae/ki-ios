//
//  CareConvoVC.swift
//  iOSKinkedIn
//
//  Created by alice on 5/13/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import Atlas

enum ReplyType {
    case none, text, choice
}

class CareConvoVC: ATLConversationViewController, ATLConversationViewControllerDataSource, ATLConversationViewControllerDelegate {
    
    private var dateFormatter = DateFormatter()
    private var replyState: ReplyType = .text

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
        self.dataSource = self
        self.delegate = self
        
        self.messageInputToolbar.displaysRightAccessoryImage = false
        self.messageInputToolbar.leftAccessoryButton = nil
        
        updateReplyState(state: .none)
        makeOptionsView()
    }
    
    private func makeOptionsView() {
        let LABEL_HEIGHT = 20
        let LABEL_PADDING = 8
        let opts: [String] = ["Yes", "No"]
        var uiOpts: [UIView] = []
        
        for o in opts {
            let lbl = UILabel()
            lbl.text = o
            lbl.textColor = UIColor.white
            lbl.backgroundColor = UIColor.blue
            lbl.textAlignment = .center
            lbl.translatesAutoresizingMaskIntoConstraints = false
            uiOpts.append(lbl)
        }
        
        let stack = UIStackView(arrangedSubviews: uiOpts)
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.distribution = .fillEqually
        stack.spacing = 8.0
        
        //self.view.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stack)
        
        let stackHeight = (LABEL_HEIGHT*uiOpts.count) + (LABEL_PADDING*(uiOpts.count-1))
        
        let ypos = NSLayoutConstraint(item: stack, attribute: .bottom, relatedBy: .equal,
                                      toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: stack, attribute: .height, relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(stackHeight))
        let xa = NSLayoutConstraint(item: stack, attribute: .leading, relatedBy: .equal,
                                    toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let xe = NSLayoutConstraint(item: stack, attribute: .trailing, relatedBy: .equal,
                                    toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        self.view.addConstraints([ypos, height, xa, xe])
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
            NSForegroundColorAttributeName: UIColor.cyan
        ]
        return NSAttributedString(string: self.dateFormatter.string(from: date) , attributes: dict)
    }
    
    public func conversationViewController(_ conversationViewController: ATLConversationViewController, attributedStringForDisplayOfRecipientStatus recipientStatus: [AnyHashable : Any]) -> NSAttributedString {
        return NSAttributedString(string: "", attributes: [:])
    }
    
    public func conversationViewController(_ viewController: ATLConversationViewController, didSend message: LYRMessage) {
        updateReplyState(state: .none)
    }
    
    public func updateReplyState(state: ReplyType){
        self.replyState = state
        
        //TODO close keyboard
        
        switch (state){
        case .text:
            self.messageInputToolbar.isHidden = false
        case .choice:
            self.messageInputToolbar.isHidden = true
        default:
            self.messageInputToolbar.isHidden = true
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
