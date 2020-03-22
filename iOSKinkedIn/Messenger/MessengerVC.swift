//
//  MessengerVC.swift
//  iOSKinkedIn
//
//  Created by Alice on 1/25/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import UIKit
import SwiftUI
import SendBirdSDK

class MessengerVC: BaseTextInputDelegate {
    
    var _profile : Profile?
    var _chan : SBDGroupChannel?
    var _convoLog: ConvoLogVC?
    
    @IBOutlet weak var textarea: MsgTextarea!
    @IBOutlet weak var sendBtn : UIButton!
    
    
    @IBOutlet weak var entryView: UIView!


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
            let caseType : CaseType = .report
            KinkedInAPI.aftercareFlow(caseType: caseType) { flow in
                print("YY got convo flow @ + \(flow.message)")
                let convo = UIStoryboard(name: "Aftercare", bundle: Bundle.main).instantiateViewController(withIdentifier: "careConvoVC") as! CheckinChatVC
                convo.setData(profile: profile, flow: flow, caseType: caseType)
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
                print("got profile data")
                let profileView = ProfileView(profile: profile, isFriend: true) {
                    print("segue back to msg")
                }
                self.view.hideToastActivity()
                let host = UIHostingController(rootView: profileView)
                self.navigationController?.pushViewController(host, animated: false)
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

        guard let profile = _profile else { return }
        
        let vc = UIHostingController(rootView: VouchView(profile: profile ))
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
