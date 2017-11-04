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

class CareConvoVC: KiConvoVC, ATLConversationViewControllerDelegate {
    
    private var replyState: ReplyType = .text
    private var stack = UIStackView()
    private var stackHeightConstraint: NSLayoutConstraint?
    private var scrollOffsetConstraint: NSLayoutConstraint?
    
    private let LABEL_HEIGHT = 40
    private let LABEL_PADDING = 8
    
    private var currentQuestion: [String: Any]? = nil
    private var tempQ: String? = nil
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(didReceiveLayerObjectsDidChangeNotification),
            name: NSNotification.Name.LYRClientObjectsDidChange,
            object: self.layerClient)
        
        _makeOptionsView()
        sendText("Case created on \(Date().description)")
    }
    
    private func _makeOptionsView() {
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.distribution = .fillEqually
        stack.spacing = 8.0
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stack)
        
        let ypos = NSLayoutConstraint(item: stack, attribute: .bottom, relatedBy: .equal,
                                      toItem: self.view, attribute: .bottom, multiplier: 1, constant: -8)
        let height = NSLayoutConstraint(item: stack, attribute: .height, relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        let xa = NSLayoutConstraint(item: stack, attribute: .leading, relatedBy: .equal,
                                    toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let xe = NSLayoutConstraint(item: stack, attribute: .trailing, relatedBy: .equal,
                                    toItem: self.view, attribute: .trailing, multiplier: 1, constant: -8)
        view.addConstraints([ypos, height, xa, xe])
        stackHeightConstraint = height
    }
    
    private func _closeOptionsView(){
        // Remove exsiting elements not tested yet
        for sv in stack.arrangedSubviews {
            sv.removeFromSuperview()
        }
        stack.isHidden = true
        
        if let _oldOffset = self.scrollOffsetConstraint {
            view.removeConstraint(_oldOffset)
        }
        self.scrollOffsetConstraint = nil
    }
    
    private func _setOptions(_ opts: [String]){
        
        for o in opts {
            let lbl = UIButton()
            lbl.setTitleColor(UIColor.white, for: .normal)
            lbl.backgroundColor = ThemeColors.msgBtn
            lbl.titleEdgeInsets = UIEdgeInsets(top: 0.5 , left: 0.0, bottom: 0.5, right: 0.0)
            lbl.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 6.0, bottom: 0.0, right: 6.0)
            lbl.layer.cornerRadius = 10
            lbl.clipsToBounds = true
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.frame.size.height = CGFloat(LABEL_HEIGHT)
            lbl.addTarget(self, action: #selector(self.optionTapped), for: .touchUpInside)
            lbl.setTitle(o, for: .normal)
            lbl.sizeToFit()
            stack.addArrangedSubview(lbl)
        }
        let stackHeight = CGFloat( (LABEL_HEIGHT*opts.count) + (3*LABEL_PADDING*(opts.count-1)) )
        let height = NSLayoutConstraint(item: stack, attribute: .height, relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: stackHeight)
        let offset = NSLayoutConstraint(
            item: self.collectionView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self.bottomLayoutGuide,
            attribute: .top,
            multiplier: 1,
            constant: -stackHeight)
        if let _oldHeight = self.stackHeightConstraint {
            view.removeConstraint(_oldHeight)
        }
        view.addConstraint(height)
        view.addConstraint(offset)
        stackHeightConstraint = height
        scrollOffsetConstraint = offset
        stack.isHidden = false

        updateReplyState(state: .choice)
    }
    
    func sendText(_ text: String){
        let part = LYRMessagePart(text: text)
        do {
            let msg = try layerClient.newMessage(with: [part], options: nil)
            try self.conversation.send(msg)
        } catch {
            print("error in sending text message")
        }
    }
    
    func optionTapped(_ sender: UIButton){

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
    
    public func conversationViewController(_ viewController: ATLConversationViewController, didSend message: LYRMessage) {
        //updateReplyState(state: .none)
    }
    
    public func conversationViewController(_ viewController: ATLConversationViewController, didFailSending message: LYRMessage, error: Error) {
        print("LYR didFailSending")
        print(error.localizedDescription)
    }
    
    public func updateReplyState(state: ReplyType){
        self.replyState = state
        
        switch (state){
        case .text:
            print("show keyboard")
            self.view.endEditing(false)
            self.view.becomeFirstResponder()
            self.messageInputToolbar.becomeFirstResponder()
            self.messageInputToolbar.isHidden = false
        case .choice:
            print("hide keyboard")
            hideKeyboard()
        default:
            print("do nothing")
        }
    }
    
    func hideKeyboard(){
        self.view.endEditing(true)
        self.messageInputToolbar.resignFirstResponder()
        self.messageInputToolbar.isHidden = true
    }
    
    func didReceiveLayerObjectsDidChangeNotification(_ notification: NSNotification){
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
