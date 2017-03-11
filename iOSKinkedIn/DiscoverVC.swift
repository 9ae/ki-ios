//
//  DiscoverVC.swift
//  iOSKinkedIn
//
//  Created by alice on 3/2/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import Toast_Swift

class DiscoverVC: UIViewController {
    
    var profileViewController: ViewProfileVC?
    @IBOutlet weak var todayMatches: UICollectionView!
    var dailyMatchesController: DailyMatchesVC
    
    var profilesQueue = [String]()
    //var fakeProfiles = [Profile]()
    
    required init?(coder aDecoder: NSCoder) {
        self.dailyMatchesController = DailyMatchesVC()
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(loadNextProfile), name: NOTIFY_NEXT_PROFILE, object: nil)
        NotificationCenter.default.addObserver(self,
           selector: #selector(reciprocalLike), name: NOTIFY_RECIPROCAL_FEEFEE, object: nil)
        
        KinkedInAPI.listProfiles { uuids in
            self.profilesQueue = uuids
            self._popProfile()
        }
        
        //fakeProfiles = ShadowUsers().users
        //self._popProfile()
        
        todayMatches.delegate = dailyMatchesController
        todayMatches.dataSource = dailyMatchesController
    }
    
    @objc func loadNextProfile() {
        self._popProfile()
    }
    
    @objc func reciprocalLike(){
        /*
        UIView.animate(withDuration: 0.25, animations: {
            self.todayMatches?.frame.origin.y += 90
        })
        */
        //TODO add cropped image to today's matches
        _showPopup(true)
    }
    
    //TODO figure out disappearing bug

    private func _showPopup(_ done: Bool) {
        var style = ToastStyle()
        style.backgroundColor = ThemeColors.action
        
        self.view.makeToast("The feelings are mutual! Start chatting!", duration: 3, position: .top, style: style)
    }
    
    private func _popProfile(){
        if(self.profileViewController == nil){
            return
        }
        print("load next profile")
        //let profile = self.fakeProfiles.removeFirst()
        //self.profileViewController?.setProfile(profile)
        let uuid = self.profilesQueue.removeFirst()
        KinkedInAPI.readProfile(uuid) { profile in
            self.profileViewController?.setProfile(profile)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "profileContainer"){
            self.profileViewController = segue.destination as? ViewProfileVC
        }
    }
    
}
