//
//  MessengerVC.swift
//  iOSKinkedIn
//
//  Created by Alice on 1/25/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import UIKit
import SendBirdSDK

class MessengerVC: UIViewController, UITextViewDelegate {
    
    var _profile : Profile?
    var _chan : SBDGroupChannel?
    var _convoLog: ConvoLogVC?
    
    @IBOutlet weak var textarea: UITextView!
    @IBOutlet weak var sendBtn : UIButton!
    
    
    @IBOutlet weak var entryView: UIView!
    @IBOutlet weak var noKeyboardConstraint : NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let profile = _profile {
            self.navigationItem.title = profile.name
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWasShown(_ notification: NSNotification) {
        print("keyboard is shown")
        guard let info = notification.userInfo else {
            print("no user info")
            return
        }
        
        guard let keyboardRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect else {
            print("failed to cast as CGRect")
            return
        }
        
        noKeyboardConstraint.constant = keyboardRect.size.height
        noKeyboardConstraint.isActive = true
        
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        print("keybaord about to hide")
        
        noKeyboardConstraint.constant =  0
        noKeyboardConstraint.isActive = true
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView == textarea){
            sendBtn.isEnabled = true
        }
    }
    
    @IBAction func onSend(_ sender: Any){
        textarea.endEditing(true)
        
        let msg = textarea.text
        if (msg?.count ?? 0) > 0 {
            print("sending ... \(msg)")
            _chan?.sendUserMessage(msg, completionHandler: { (_msg, _error) in
                if _msg != nil {
                    print("message sent success")
                } else {
                    print(_error)
                }
            })
        }
        
        textarea.text = ""
        sendBtn.isEnabled = false
    }

    func setData(_ profile: Profile){
        self._profile = profile
        
        SBDGroupChannel.createChannel(withUserIds: [profile.uuid], isDistinct: true) { (chan, error) in
            print("creating channel")
            
            self._chan = chan
            
            if let err = error {
                print(err)
            } else {
                print("channel created sucessfully")
                self.initLoadMessages()
            }
        }
    }
    
    func initLoadMessages(){
        guard let q = _chan?.createPreviousMessageListQuery() else {
            print("fail to create query")
            return
        }
        
        print("query created")
        
        q.loadPreviousMessages(withLimit: 20, reverse: true) { (_messages, _error) in
            if let msglog = _messages, let convoLog = self._convoLog {
                var toAdd : [Message] = []
                let messages = msglog.reversed()
                for _msg in messages {
                    guard let msg = _msg as? SBDUserMessage else { continue }
                    guard let body = msg.message else { continue }
                    var isMe = false
                    if let sender = msg.sender, let myId = self._profile?.uuid {
                        isMe = sender.userId == myId
                    }
                    toAdd.append(Message(body: body, isMe: isMe))
                }
                convoLog.addMessages(toAdd)
            } else {
                print(_error)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("check seuges")
        if segue.identifier == "convoEmbed" {
            print("is segue as convo embed")
            self._convoLog = segue.destination as? ConvoLogVC
        }
    }
    

}
