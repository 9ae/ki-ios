//
//  TempConvoVC.swift
//  iOSKinkedIn
//
//  Created by Alice on 12/7/19.
//  Copyright © 2019 KinkedIn. All rights reserved.
//

import UIKit

class TempConvoVC: UIViewController {
    
    var profile: Profile?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
        
        self.navigationItem.title = profile?.name
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
            guard let user_uuid = self.profile?.uuid else {
                return
            }
           // TODO make aftercare convo
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
        scheduleScreen.withUser = profile
        self.navigationController?.pushViewController(scheduleScreen, animated: false)
    }
    
    func goToViewProfile(){
        
        if let uuid = profile?.uuid {
            
            self.view.makeToastActivity(.center)
            
            KinkedInAPI.readProfile(uuid) { profile in
                let profileView = ViewProfileVC(profile)
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
    
    func vouch(){
        let vc = UIStoryboard(name: "Connect", bundle: Bundle.main).instantiateViewController(withIdentifier: "vouchIntro") as! VouchIntroVC
        vc.subjectName = profile?.name
        vc.subjectUUID = profile?.uuid
        self.navigationController?.pushViewController(vc, animated: false)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}