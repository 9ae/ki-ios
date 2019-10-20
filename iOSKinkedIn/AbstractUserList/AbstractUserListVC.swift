//
//  UserListVC.swift
//  iOSKinkedIn
//
//  Created by Alice Q Wong on 11/7/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class AbstractUserListVC: UITableViewController {
    
    private let CELL_ID = "userCell"
    private var selected: [Profile] = [Profile]()
    
    var profiles: [Profile] = [Profile]()
    var doneCallbackSingle: ((_ selected: Profile) -> Void)?
    var doneCallbackMulti: ((_ selected: [Profile]) -> Void)?


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isMutliSelect() -> Bool {
        return self.tableView.allowsMultipleSelection
    }
    
    func setMultiSelect(_ isMulti: Bool) {
        self.tableView.allowsMultipleSelection = isMulti
    }

    @IBAction func onDone(_ sender: Any) {
        if self.isMutliSelect() {
            if let doneCallback = doneCallbackMulti {
                doneCallback(selected)
            }
        } else {
            if let doneCallback = doneCallbackSingle, selected.count == 1 {
                doneCallback(selected[0])
            }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        
        if let userCell = cell as? UserCell {
            let profile = profiles[indexPath.row]
            userCell.set(profile.picture_public_id!, profile.name)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selPro = profiles[indexPath.row]
        if (!self.isMutliSelect()) {
            selected.removeAll()
        }
        selected.append(selPro)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
