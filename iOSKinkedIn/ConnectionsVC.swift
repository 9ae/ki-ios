//
//  ConnectionsVC.swift
//  iOSKinkedIn
//
//  Created by alice on 3/11/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

enum SegmentType {
    case reciprocals, partners , disconnects
}

struct ProfileList {
    var isFetched = false
    var data = [Profile]()
}
 
class ConnectionsVC: UITableViewController {
    
    var segmentMode : SegmentType = .reciprocals
    
    var profiles: [SegmentType: ProfileList] = [
        .reciprocals : ProfileList(),
        .partners : ProfileList(),
        .disconnects : ProfileList()
    ]
    
    var selectedProfile: Profile?
    
    @IBOutlet var segment: UISegmentedControl!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadReciprocals()
        
        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    func loadReciprocals(){
        
        let isFetched = (self.profiles[.reciprocals]?.isFetched) ?? false
        
        if isFetched {
            self.tableView.reloadData()
        } else {
            KinkedInAPI.connections { profiles in
                self.profiles[.reciprocals] = ProfileList(isFetched: true, data: profiles)
                if profiles.isEmpty {
                    let alert = emptyList(
                        title: "No connections yet",
                        msg: "Discover kinky people near you.",
                        actionLabel: "Discover!",
                        action: { a in
                            self.tabBarController?.selectedIndex = 1
                    })
                    self.present(alert, animated: false)
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func loadPartners(){

        let isFetched = (self.profiles[.partners]?.isFetched) ?? false
        
        if isFetched {
            self.tableView.reloadData()
        }
        else {
            KinkedInAPI.partners { profiles in
                self.profiles[.partners] = ProfileList(isFetched: true, data: profiles)
                if profiles.isEmpty {
                    let alert = emptyList(
                        title: "No partners yet",
                        msg: "If you have existing partners, why not send them a partner request and invite them to KinkedIn?",
                        actionLabel: "Invite Partner",
                        action: nil)
                    // TODO: interface invite partner modules
                    self.present(alert, animated: false)
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func loadDC(){
        segmentMode = .disconnects
        let isFetched = (self.profiles[.disconnects]?.isFetched) ?? false
        
        if isFetched {
            self.tableView.reloadData()
            return
        }
        KinkedInAPI.blockedUsers { profiles in
            if profiles.isEmpty {
                let alert = UIAlertController(title: "No disconnected users", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: false)
            }
            else {
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    func unblock(_ user: Profile){
        KinkedInAPI.unblockUser(user.uuid)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let p = self.profiles[segmentMode] {
            return p.data.count
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "connectionCell", for: indexPath)
        
        if let cc = cell as? ConnectionCell, let p = self.profiles[segmentMode] {
            let profile = p.data[indexPath.row]
            cc.name.text = profile.name
            cc.setProfilePicture(profile.picture_public_id!)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let p = self.profiles[segmentMode] else {
            return
        }
        
        if (segmentMode == .partners || segmentMode == .reciprocals) {
        let convoVC = LayerHelper.makeConvoVC(p.data[indexPath.row])
            self.navigationController?.pushViewController(convoVC, animated: false)
        }
    }
    
    @objc func segmentChanged(){
        switch segment.selectedSegmentIndex {
        case 1:
            self.segmentMode = .partners
            loadPartners()
            break
        case 2:
            self.segmentMode = .disconnects
            loadDC()
            break
        default:
            self.segmentMode = .reciprocals
            loadReciprocals()
            break
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
