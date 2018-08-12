//
//  ConvoVC.swift
//  iOSKinkedIn
//
//  Created by alice on 5/12/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class ConvoVC: KiConvoVC {
    
    var profile: Profile?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hidesBottomBarWhenPushed = true
        //let scheduleEvent = UIBarButtonItem(image: #imageLiteral(resourceName: "calendar"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.onScheduleDate))
        //let viewProfile = UIBarButtonItem(image: #imageLiteral(resourceName: "info"), style: .plain, target: self, action: #selector(self.onViewProfile))
        //self.navigationItem.setRightBarButtonItems([viewProfile, scheduleEvent], animated: false)

        self.navigationItem.setRightBarButton(
            UIBarButtonItem(
                barButtonSystemItem: .action,
                target: self,
                action: #selector(self.actionSheetButtonPressed)
            ),
            animated: false)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Chat", style: .plain, target: nil, action: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func actionSheetButtonPressed(sender: UIButton) {
        let alert =  UIAlertController(title: "More Options", message: "", preferredStyle: .actionSheet)
        let viewProfile = UIAlertAction(title: "View Profile", style: .default) { (alert: UIAlertAction!) -> Void in
            self.goToViewProfile()
        }
        
        let scheduleDate = UIAlertAction(title: "Schedule Date", style: .default) { (alert: UIAlertAction!) -> Void in
            self.goToScheduleScreen()
        }
        
        let report = UIAlertAction(title: "Raise Issue", style: .default) { (alert: UIAlertAction!) -> Void in
            guard let user_uuid = self.profile?.uuid else {
                return
            }
            let convo = CareConvoVC(layerClient: LayerHelper.client!)
            do{
                convo.conversation = try LayerHelper.startConvo(
                    withUser: "aftercare",
                    distinct: false,
                    metadata: [
                        "about_user_id": user_uuid,
                        "case_type": "report"
                    ])
                try convo.conversation.synchronizeAllMessages(.toFirstUnread)
                convo.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(convo, animated: false)
            } catch {
                print("failed to start aftercare convo")
            }
        }
        
        let block = UIAlertAction(title: "Disconnect", style: .destructive) { (alert: UIAlertAction!) -> Void in
            self.blockUser()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction!) -> Void in
            print("do nothing")
        }
        
        alert.addAction(viewProfile)
        alert.addAction(scheduleDate)
        alert.addAction(report)
        alert.addAction(block)
        alert.addTopSpace()
        alert.addAction(cancel)
        present(alert, animated: false)
    }

    func goToScheduleScreen(){
        let scheduleScreen = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ScheduleDateVC") as! ScheduleDateVC
        scheduleScreen.withUser = profile
        self.navigationController?.pushViewController(scheduleScreen, animated: false)
    }
    
    func goToViewProfile(){
        
        if let uuid = profile?.uuid {
            
            self.view.makeToastActivity(.center)
            
            KinkedInAPI.readProfile(uuid) { profile in
                let profileView = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "discoverProfileVC") as! DiscoverProfile
                profileView.setProfile(profile, isDiscoverMode: false)
                self.view.hideToastActivity()
                self.navigationController?.pushViewController(profileView, animated: false)
            }
        
        }
    }
    
    func blockUser(){
        if let uuid = profile?.uuid {
            KinkedInAPI.blockUser(uuid)
        }
        self.navigationController?.popViewController(animated: false)
    }
    
}
