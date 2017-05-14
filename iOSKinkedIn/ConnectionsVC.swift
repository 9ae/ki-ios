//
//  ConnectionsVC.swift
//  iOSKinkedIn
//
//  Created by alice on 3/11/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class ConnectionsVC: UITableViewController {
    
    var reciprocals: [Profile] = [Profile]()
    var selectedProfile: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        KinkedInAPI.connections { profiles in
            self.reciprocals = profiles
            self.tableView.reloadData()
        }

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
        // #warning Incomplete implementation, return the number of rows
        return reciprocals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "connectionCell", for: indexPath)
        
        if let cc = cell as? ConnectionCell {
            let profile = reciprocals[indexPath.row]
            cc.name.text = profile.name
            cc.setProfilePicture(profile.picture_public_id!)
        }

        return cell
    }
    /*
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.selectedProfile = reciprocals[indexPath.row]
        return indexPath
    }
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profile = reciprocals[indexPath.row]
        do {
            let convo = ConvoVC(layerClient: LayerHelper.client!)
            convo.title = profile.name
            convo.displaysAddressBar = false
            convo.conversation = try LayerHelper.startConvo(withUser: profile.neoId)
            self.navigationController?.pushViewController(convo, animated: false)
        } catch {
            print("layer failed to start convo")
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
        if(segue.identifier == "connect2profile") {
            if let vc = segue.destination as? (CProfile){
                vc.setProfile(profile: self.selectedProfile!)
            }
        }
    }
    

}
