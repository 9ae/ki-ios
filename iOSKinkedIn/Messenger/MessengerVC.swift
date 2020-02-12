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
        
         self.hidesBottomBarWhenPushed = true
        
        self.navigationItem.setRightBarButton(
            UIBarButtonItem(
                image: #imageLiteral(resourceName: "more"),
                style: .plain,
                target: self,
                action: #selector(self.actionSheetButtonPressed)
            ),
            animated: false)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Chat", style: .plain, target: nil, action: nil)

        
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
            _convoLog?.addMyMessage(msg!)
        }
        
        textarea.text = ""
        sendBtn.isEnabled = false
    }

    func setData(_ profile: Profile){
        self._profile = profile
        
        SBDGroupChannel.createChannel(withUserIds: [profile.uuid], isDistinct: true) { (chan, error) in
            print("creating channel")
            
            self._chan = chan
            if let ch = chan {
                print("get existing convo")
                self._convoLog?.setData(theirId: profile.uuid, chan: ch)
            } else {
                print(error)
            }
        }
    }
    
    @objc func actionSheetButtonPressed(sender: UIButton) {
        let alert =  UIAlertController(title: "More Options", message: "", preferredStyle: .actionSheet)
        let viewProfile = UIAlertAction(title: "View Profile", style: .default) { (alert: UIAlertAction!) -> Void in
            self.goToViewProfile()
        }
        
        let scheduleDate = UIAlertAction(title: "Schedule Aftercare", style: .default) { (alert: UIAlertAction!) -> Void in
            self.goToScheduleScreen()
        }
        
        let report = UIAlertAction(title: "Reach Out to Care Team", style: .default) { (alert: UIAlertAction!) -> Void in
            guard let profile = self._profile else {
                return
            }
            
            print("YY getting convo flow")
            KinkedInAPI.aftercareFlow(caseType: .report) { flow in
                print("YY got convo flow @ + \(flow.message)")
                let convo = UIStoryboard(name: "Aftercare", bundle: Bundle.main).instantiateViewController(withIdentifier: "careConvoVC") as! CheckinChatVC
               convo.setData(profile: profile, flow: flow)
               self.navigationController?.pushViewController(convo, animated: false)
            }
            self.view.makeToastActivity(.center)
        }
        
        let block = UIAlertAction(title: "Disconnect", style: .destructive) { (alert: UIAlertAction!) -> Void in
            self.blockUser()
        }
        
        let vouch = UIAlertAction(title: "Vouch For", style: .default) {(alert: UIAlertAction!) -> Void in
            self.vouch()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction!) -> Void in
            print("do nothing")
        }
        
        alert.addAction(viewProfile)
        alert.addAction(scheduleDate)
        alert.addAction(report)
        alert.addAction(block)
        alert.addTopSpace()
        alert.addAction(vouch)
        alert.addAction(cancel)
        present(alert, animated: false)
    }
    
    func goToScheduleScreen(){
        let scheduleScreen = UIStoryboard(name: "Connect", bundle: Bundle.main).instantiateViewController(withIdentifier: "ScheduleDateVC") as! ScheduleDateVC
        scheduleScreen.withUser = _profile
        self.navigationController?.pushViewController(scheduleScreen, animated: false)
    }
    
    func goToViewProfile(){
        
        if let uuid = _profile?.uuid {
            
            self.view.makeToastActivity(.center)
            
            KinkedInAPI.readProfile(uuid) { profile in
                let profileView = ViewProfileVC(profile)
                self.view.hideToastActivity()
                self.navigationController?.pushViewController(profileView, animated: false)
            }
            
        }
    }
    
    func blockUser(){
        if let uuid = _profile?.uuid {
            KinkedInAPI.blockUser(uuid)
        }
        self.navigationController?.popViewController(animated: false)
    }
    
    func vouch(){
        let vc = UIStoryboard(name: "Connect", bundle: Bundle.main).instantiateViewController(withIdentifier: "vouchIntro") as! VouchIntroVC
        vc.subjectName = _profile?.name
        vc.subjectUUID = _profile?.uuid
        self.navigationController?.pushViewController(vc, animated: false)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("check seuges")
        if segue.identifier == "convoEmbed" {
            print("is segue as convo embed")
            self._convoLog = segue.destination as? ConvoLogVC
        }
    }
    

}
