//
//  MessengerVC.swift
//  iOSKinkedIn
//
//  Created by Alice on 1/25/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import UIKit

class CheckinChatVC: UIViewController, UITextViewDelegate {
    
    var _profile : Profile?
    var _convoLog: SimpleLogVC?
    
    var flow : CareQuestion
    

    @IBOutlet weak var entryView: UIStackView!
    @IBOutlet weak var noKeyboardConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var textarea: UITextView!
    @IBOutlet weak var sendBtn : UIButton!
    
    @IBOutlet weak var optionsView: UIStackView!

    required init?(coder: NSCoder) {
        self.flow = CareQuestion("There was an error launch after care support. Please contact our staff at help@kinkedin.app", type: .statement, followup: [])
        
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let profile = _profile {
            // TODO change depending on checkin type
            self.navigationItem.title = "Checkin about:" + profile.name
        }
        
         self.hidesBottomBarWhenPushed = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("=== AFTER CARE CONVO NOW ===")
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
        
        noKeyboardConstraint.constant =  8
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
            
        }
        
        textarea.text = ""
        sendBtn.isEnabled = false
    }

    func setData(profile: Profile, flow: CareQuestion){
        self._profile = profile
        self.flow = flow
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "convoEmbed" {
            self._convoLog = segue.destination as? SimpleLogVC
            
            if let log = _convoLog {
                print("first msg")
                log.botSay(flow.message)
            }
        }
    }
    

}

