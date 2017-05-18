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

class CareConvoVC: ATLConversationViewController,
    ATLConversationViewControllerDataSource,
    ATLConversationViewControllerDelegate{
    
    private var dateFormatter = DateFormatter()
    private var replyState: ReplyType = .text
    private var stack = UIStackView()
    private var stackHeightConstraint: NSLayoutConstraint?
    
    private let LABEL_HEIGHT = 30
    private let LABEL_PADDING = 8
    
    private var currentQuestion: [String: Any]? = nil
    private var tempQ: String? = nil
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        /*
        print("client ready \(LayerHelper.client != nil)")
        do {
            self.layerClient = LayerHelper.client!
            self.conversation = try LayerHelper.startConvo(withUser: "aftercare")
            print("set conversation \(self.conversation)")
        } catch {
            print("failed to start aftercare convo")
        }
        */
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        self.displaysAddressBar = false
        
        self.navigationItem.title = "Aftercare"
        self.dataSource = self
        self.delegate = self
        
        self.messageInputToolbar.displaysRightAccessoryImage = false
        self.messageInputToolbar.leftAccessoryButton = nil
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(didReceiveLayerObjectsDidChangeNotification),
            name: NSNotification.Name.LYRClientObjectsDidChange,
            object: self.layerClient)
        
        _makeOptionsView()
        
    }
    
    private func _makeOptionsView() {
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.distribution = .fillEqually
        stack.spacing = 8.0
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stack)
        
        let ypos = NSLayoutConstraint(item: stack, attribute: .bottom, relatedBy: .equal,
                                      toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: stack, attribute: .height, relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        let xa = NSLayoutConstraint(item: stack, attribute: .leading, relatedBy: .equal,
                                    toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let xe = NSLayoutConstraint(item: stack, attribute: .trailing, relatedBy: .equal,
                                    toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        view.addConstraints([ypos, height, xa, xe])
        stackHeightConstraint = height
    }
    
    private func _closeOptionsView(){
        // Remove exsiting elements not tested yet
        for sv in stack.arrangedSubviews {
            sv.removeFromSuperview()
        }
        stack.isHidden = true
    }
    
    private func _setOptions(_ opts: [String]){
        
        for o in opts {
            let lbl = UIButton()
            lbl.setTitle(o, for: .normal)
            lbl.setTitleColor(UIColor.white, for: .normal)
            lbl.backgroundColor = UIColor.blue
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.frame.size.height = CGFloat(LABEL_HEIGHT)
            lbl.addTarget(self, action: #selector(self.optionTapped), for: .touchUpInside)
            stack.addArrangedSubview(lbl)
        }
        let stackHeight = (LABEL_HEIGHT*opts.count) + (LABEL_PADDING*(opts.count-1))
        let height = NSLayoutConstraint(item: stack, attribute: .height, relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(stackHeight))
        if let _oldHeight = self.stackHeightConstraint {
            view.removeConstraint(_oldHeight)
        }
        view.addConstraint(height)
        stackHeightConstraint = height
        updateReplyState(state: .choice)
    }
    
    func optionTapped(_ sender: UIButton){
        print("response \(sender.title(for: .normal))")
        guard let text = sender.title(for: .normal) else {
            print("cant find")
            return
        }
        let part = LYRMessagePart(text: text)
        do {
            let msg = try layerClient.newMessage(with: [part], options: nil)
            try self.conversation.send(msg)
            
            _closeOptionsView()

        } catch {
            print("error in sending message")
        }
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
        //updateReplyState(state: .none)
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
    
    func didReceiveLayerObjectsDidChangeNotification(_ notification: NSNotification){
        print("something change")
        guard let info = notification.userInfo else {
            return
        }
        
        guard let changes = info[LYRClientObjectChangesUserInfoKey] as? NSArray else {
            return
        }
        for ch in changes{
            if let change = ch as? LYRObjectChange {
                if let message = isMessageRecieved(change) {
                    interceptMessage(message)
                }
            }
        }
    }
    
    private func isMessageRecieved(_ change: LYRObjectChange) -> LYRMessage? {
        if(change.type == .create){
            if let message = change.object as? LYRMessage {
                if(message.sender.userID=="aftercare"){
                    return message
                }
            }
        }
        return nil
    }
    
    private func interceptMessage(_ message: LYRMessage){
        print("interecepted message")
        if(message.parts.count > 1 && message.parts.last?.mimeType == "application/json"){
            if let headerData = message.parts.last?.data {
                do {
                    currentQuestion = try JSONSerialization.jsonObject(with: headerData, options: .mutableContainers) as? [String: Any]
                    if let responseType = currentQuestion?["response_type"] as? String {
                        if (responseType == "choice"){
                            if let options = currentQuestion?["options"] as? [String] {
                                _setOptions(options)
                            }
                        }
                        else if (responseType == "none"){
                            updateReplyState(state: .none)
                        }
                        else {
                            updateReplyState(state: .text)
                        }
                    }
                } catch {
                    print(error)
                }
            }
            
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
