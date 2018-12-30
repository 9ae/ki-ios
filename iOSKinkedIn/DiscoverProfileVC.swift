//
//  DiscoverProfileVC.swift
//  iOSKinkedIn
//
//  Created by alice on 12/17/18.
//  Copyright © 2018 KinkedIn. All rights reserved.
//

import UIKit

class DiscoverProfileVC: CodeProfileVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.kinks.isHidden = true
        
        let likeBtn = UIButton()
        likeBtn.setImage(#imageLiteral(resourceName: "profile_like"), for: .normal)
        view.addSubview(likeBtn)
        likeBtn.translatesAutoresizingMaskIntoConstraints = false
        likeBtn.topAnchor.constraint(equalTo: self.view.topAnchor, constant: CodeProfileVC.imageHeight - 40).isActive = true
        likeBtn.heightAnchor.constraint(equalToConstant: 48).isActive = true
        likeBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50.0).isActive = true
        likeBtn.widthAnchor.constraint(equalToConstant: 48).isActive = true
        likeBtn.addTarget(self, action: #selector(self.like), for: .touchDown)
        
        let skipBtn = UIButton()
        skipBtn.setImage(#imageLiteral(resourceName: "profile_skip"), for: .normal)
        view.addSubview(skipBtn)
        skipBtn.translatesAutoresizingMaskIntoConstraints = false
        skipBtn.topAnchor.constraint(equalTo: likeBtn.topAnchor, constant: 12).isActive = true
        skipBtn.heightAnchor.constraint(equalToConstant: 32).isActive = true
        skipBtn.widthAnchor.constraint(equalToConstant: 32).isActive = true
        skipBtn.leadingAnchor.constraint(equalTo: likeBtn.trailingAnchor, constant: 8).isActive = true
        skipBtn.addTarget(self, action: #selector(self.skip), for: .touchDown)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func back(){
        self.navigationController?.popViewController(animated: false)
        NotificationCenter.default.post(
            name: NOTIFY_CLOSE_PROFILE,
            object: nil,
            userInfo: ["profile_uuid": profile.uuid]
        )
    }
    
    private func updateMatchLimits(match_limit: Int, matches_today: Int) {
        let defaults = UserDefaults.standard
        defaults.set(matches_today, forKey: UD_MATCHES_TODAY)
        defaults.set(matches_today < match_limit, forKey: UD_CAN_LIKE)
        let existing_limit = defaults.integer(forKey: UD_MATCH_LIMIT)
        if (existing_limit != match_limit) {
            defaults.set(match_limit, forKey: UD_MATCH_LIMIT)
        }
    }
    
    @objc private func like(_ sender: AnyObject) {
        if !UserDefaults.standard.bool(forKey: UD_CAN_LIKE) {
            return
        }
        
        KinkedInAPI.likeProfile(self.profile.uuid) { reciprocal, match_limit, matches_today in
            if(reciprocal) {
                self.updateMatchLimits(match_limit: match_limit, matches_today: matches_today)
            }
        }
        back()
    }
    
    @objc private func skip(_ sender: AnyObject) {
        KinkedInAPI.skipProfile(self.profile.uuid)
        back()
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
