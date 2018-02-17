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

class DiscoveryListVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var profilesQueue = [String]()
    var profiles = [Profile]()
    
    var selectedProfile : Profile?

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
            // TODO text view with link that takes them to their connections screen
            print("In text: Daily match limit reached, spend time getting to know your new connections")
        }
        
        self.collectionView!.register(ThumbnailMatchCell.self, forCellWithReuseIdentifier: matchesCellIdentifier)
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        addTopSpace()
        //TODO check daily match limit not reached
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
            return 7
        }
        return profiles.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.section == 0) {
            return collectionView.dequeueReusableCell(withReuseIdentifier: matchesCellIdentifier, for: indexPath)
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        
        cell.setContent(profiles[indexPath.row])
    
        return cell
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
        if(indexPath.section == 1){
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
