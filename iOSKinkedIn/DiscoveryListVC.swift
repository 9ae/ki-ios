//
//  DiscoveryListVC.swift
//  iOSKinkedIn
//
//  Created by alice on 5/22/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

private let reuseIdentifier = "profileCell"
private let matchesCellIdentifier = "thMatch"
private let textNoteIdentifier = "textNote"

private let SEGUE_TO_READ_PROFILE = "revealProfile"

class DiscoveryListVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var profiles = [Profile]()
    var todayMatches = [Profile]()
    
    var selectedProfile : Profile?
    var isMatchLimitReached = false
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
                
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes - Don't do this if you have stuff on your storyboard for this cell
        // self.collectionView!.register(ProfileCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        self.view.makeToastActivity(.center)
        let isCanLike = UserDefaults.standard.bool(forKey: UD_CAN_LIKE)
        if isCanLike {
            KinkedInAPI.listProfiles { profiles in
                self.profiles = profiles
                self.collectionView?.reloadData()
                self.view.hideToastActivity()
                
                if profiles.isEmpty {
                    let alert = emptyList(
                        title: "No new profiles",
                        msg: "Now could be a great time to get to know your existing connections",
                        actionLabel: "See Connections",
                        action: { a in
                            self.tabBarController?.selectedIndex = 1
                    })

                    self.present(alert, animated: false)
                }
            }
        } else {
            self.view.hideToastActivity()
            isMatchLimitReached = true
        }

        KinkedInAPI.dailyMatches(){ matches in
            self.todayMatches = matches
            self.collectionView?.reloadData()
        }

        self.collectionView!.register(ThumbnailMatchCell.self, forCellWithReuseIdentifier: matchesCellIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateProfilesList), name: NOTIFY_SKIP_PROFILE, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return UD_MATCH_LIMIT_VALUE
            //return UserDefaults.standard.integer(forKey: UD_MATCH_LIMIT)
        } else {
            if isMatchLimitReached {
                return 1
            }
            return profiles.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.section == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: matchesCellIdentifier, for: indexPath) as! ThumbnailMatchCell
            if(indexPath.row < todayMatches.count){
                let profile = todayMatches[indexPath.row]
                cell.setData(profile.picture_public_id!, name: profile.name)
            }
            return cell
        } else if isMatchLimitReached {
            return collectionView.dequeueReusableCell(withReuseIdentifier: textNoteIdentifier, for: indexPath)
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
            cell.setContent(profiles[indexPath.row])
            return cell
        }
    }

    // MARK: UICollectionViewDelegate
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            if(indexPath.row < todayMatches.count){
                onDailyMatchTouched(todayMatches[indexPath.row])
            }
        } else if !isMatchLimitReached {
            self.view.makeToastActivity(.center)
            let profileUUID = profiles[indexPath.row].uuid
            KinkedInAPI.readProfile(profileUUID, callback: { profile in
                self.selectedProfile = profile
                let profileView = DiscoverProfileVC(profile)
                self.view.hideToastActivity()
                self.navigationController?.pushViewController(profileView, animated: false)
                //self.performSegue(withIdentifier: SEGUE_TO_READ_PROFILE, sender: self)
            })
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat
        let height : CGFloat
        
        if indexPath.section == 0 {
            width = 120
            height = 40
        } else {
            width = self.view.frame.width - 10
            height = width  / 1.62
        }
        return CGSize(width: width, height: height)
    }
    
    func onDailyMatchTouched(_ profile: Profile) {
        print("open action sheet")
        let alert =  UIAlertController(title: profile.name, message: "What would you like to do?", preferredStyle: .actionSheet)
        

        let viewProfile = UIAlertAction(title: "See profile", style: .default) { (alert: UIAlertAction!) -> Void in
            self.view.makeToastActivity(.center)
            
            KinkedInAPI.readProfile(profile.uuid) { profile in
                self.view.hideToastActivity()
                let profileView = ViewProfileVC(profile)
                self.navigationController?.pushViewController(profileView, animated: false)
            }
        }
        let talkTo = UIAlertAction(title: "Start chatting", style: .default) { (alert: UIAlertAction!) -> Void in
            let convo = LayerHelper.makeConvoVC(profile)
                self.navigationController?.pushViewController(convo, animated: false)
//            } else {
//                print("something went wrong in attempt to start convo with \(profile.name)")
//            }
        }
        let cancel = UIAlertAction(title: "Nothing", style: .cancel)
        
        alert.addAction(talkTo)
        alert.addAction(viewProfile)
        alert.addTopSpace()
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    @objc func updateProfilesList(notification: NSNotification){
        if let info = notification.userInfo {
            if let uuid = info["profile_uuid"] as? String {
                let np = profiles.filter({p in p.uuid != uuid})
                self.profiles = np
                self.collectionView?.reloadData()
            }
        }
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
