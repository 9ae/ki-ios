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

class DiscoveryListVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var profilesQueue = [String]()
    var profiles = [Profile]()
    var todayMatches = [Profile]()
    
    var selectedProfile : Profile?
    var isMatchLimitReached = false

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
            KinkedInAPI.listProfiles { uuids in
                self.profilesQueue = uuids
                print("Got \(uuids.count) profiles")
                self._popProfile()
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
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        addTopSpace()
        //TODO check daily match limit not reached
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func _popProfile(){
        if profilesQueue.isEmpty {
            return
        }
        
        let profile_uuid = self.profilesQueue.removeFirst()
        KinkedInAPI.readProfile(profile_uuid) { profile in
            self.profiles.append(profile)
            if(self.profiles.count == 1){
                self.view.hideToastActivity()
            }
            self.collectionView?.reloadData()
            self._popProfile()
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let discoverProfile = segue.destination as? DiscoverProfile {
            discoverProfile.setProfile(selectedProfile!)
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            //TODO get from user default limits
            return UserDefaults.standard.integer(forKey: UD_MATCH_LIMIT)
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
                cell.setImage(profile.picture_public_id!)
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
            selectedProfile = profiles[indexPath.row]
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat
        let height : CGFloat
        
        if indexPath.section == 0 {
            width = 40
            height = 40
        } else {
            width = 300
            height = 185
        }
        return CGSize(width: width, height: height)
    }
    
    func onDailyMatchTouched(_ profile: Profile) {
        let alert =  UIAlertController(title: profile.name, message: "What would you like to do?", preferredStyle: .actionSheet)
        let viewProfile = UIAlertAction(title: "See profile", style: .default) { (alert: UIAlertAction!) -> Void in
            self.view.makeToastActivity(.center)
            
            KinkedInAPI.readProfile(profile.neoId) { profile in
                let profileView = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "discoverProfileVC") as! DiscoverProfile
                profileView.setProfile(profile, isDiscoverMode: false)
                self.view.hideToastActivity()
                self.navigationController?.pushViewController(profileView, animated: false)
            }
        }
        let talkTo = UIAlertAction(title: "Start chatting", style: .default) { (alert: UIAlertAction!) -> Void in
            print("start convo with new friend")
            if let convo = LayerHelper.makeConvoVC(profile) {
                self.navigationController?.pushViewController(convo, animated: false)
            } else {
                print("something went wrong in attempt to start convo with \(profile.name)")
            }
        }
        let cancel = UIAlertAction(title: "Nothing", style: .cancel) { (alert: UIAlertAction!) -> Void in
            print("do nothing")
        }
        
        alert.addAction(viewProfile)
        alert.addAction(talkTo)
        alert.addTopSpace()
        alert.addAction(cancel)
        
        present(alert, animated: true)
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
