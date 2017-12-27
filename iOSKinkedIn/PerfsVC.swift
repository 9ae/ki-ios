//
//  PerfsVC.swift
//  iOSKinkedIn
//
//  Created by alice on 6/28/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class PerfsVC: UITableViewController {
    
    @IBOutlet var minAge: UITextField!
    @IBOutlet var maxAge: UITextField!
    @IBOutlet var checkinHours: UITextField!
    
    var preferences: PreferenceFilters?
    var profile: Profile?

    override func viewDidLoad() {
        super.viewDidLoad()

        var checkinTime = UserDefaults.standard.integer(forKey: UD_CHECKIN_TIME)
        if(checkinTime == 0){
            checkinTime = UD_CHECKIN_TIME_VALUE
        }
        checkinHours.text = String(describing: checkinTime)
        
        KinkedInAPI.myself{ profile in
            let preferences = profile.preferences
            self.minAge.text = String(describing: preferences?.minAge ?? 0)
            self.maxAge.text = String(describing: preferences?.maxAge ?? 0)
            self.profile = profile
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { 
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 4
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let checkinTime = Int(checkinHours.text!) {
            UserDefaults.standard.set(checkinTime, forKey: UD_CHECKIN_TIME)
        }
        
        var prefers = [String:Any]()
        if let min_age = Int(minAge.text!) {
            prefers["min_age"] = min_age
        }
        
        if let max_age = Int(maxAge.text!) {
            prefers["max_age"] = max_age
        }
        
        let params = ["prefers": prefers]
        KinkedInAPI.updateProfile(params)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 2 && indexPath.row == 0) {
            self.goToBlockedUsers()
        }
    }
    
    func unblockUsers(_ selected: [Profile]) {
        for user in selected {
            KinkedInAPI.unblockUser(user.neoId)
        }
        self.navigationController?.popViewController(animated: false)
    }
    
    func goToBlockedUsers(){
        self.view.makeToastActivity(.center)
        KinkedInAPI.blockedUsers { profiles in
            let blockUserVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AbstractUserListVC") as! AbstractUserListVC
            blockUserVC.profiles.append(contentsOf: profiles)
            blockUserVC.setMultiSelect(true)
            blockUserVC.doneCallbackMulti = self.unblockUsers
            blockUserVC.navigationItem.rightBarButtonItem?.title = "Reconnect"
            blockUserVC.navigationItem.title = "Disconnected"
            self.view.hideToastActivity()
            self.navigationController?.pushViewController(blockUserVC, animated: false)
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier=="prefGenders", let vc = segue.destination as? GendersVC {
            vc.profile = profile
            vc.updatePreferencesMode = true
        }
        
        if segue.identifier=="prefRoles", let vc = segue.destination as? RolesVC {
            vc.profile = profile
            vc.updatePreferencesMode = true
        }
        
        
    }
    

}
