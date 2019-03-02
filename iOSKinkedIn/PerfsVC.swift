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
    let numberToolbar: UIToolbar = UIToolbar()
    
    var valMinAge = 0
    var valMaxAge = 0
    var preferences: PreferenceFilters?
    var profile: Profile?

    override func viewDidLoad() {
        super.viewDidLoad()

        var checkinTime = UserDefaults.standard.integer(forKey: UD_CHECKIN_TIME)
        if(checkinTime == 0){
            checkinTime = UD_CHECKIN_TIME_VALUE
        }
        
        KinkedInAPI.myself { profile in
            let preferences = profile.preferences
            self.valMinAge = preferences?.minAge ?? 0
            self.valMaxAge = preferences?.maxAge ?? 0
            self.minAge.text = String(describing: self.valMinAge)
            self.maxAge.text = String(describing: self.valMaxAge)
            self.profile = profile
        }
        
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.keyboardClose)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.keyboardDone))
        ]
        numberToolbar.sizeToFit()
        
        minAge.inputAccessoryView = numberToolbar
        maxAge.inputAccessoryView = numberToolbar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { 
        return 1
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        var prefers = [String:Any]()
        prefers["min_age"] = valMinAge
        prefers["max_age"] = valMaxAge
        
        let params = ["prefers": prefers]
        KinkedInAPI.updateProfile(params)
        
    }

    @objc
    func keyboardClose(_ sender: AnyObject){
        if self.minAge.isFirstResponder {
            self.minAge.text = String(describing: valMinAge)
            self.minAge.resignFirstResponder()
            return
        }
        
        if self.maxAge.isFirstResponder {
            self.maxAge.text = String(describing: valMaxAge)
            self.maxAge.resignFirstResponder()
            return
        }
        
    }
    
    @objc
    func keyboardDone(_ sender: AnyObject){
        if self.minAge.isFirstResponder {
            valMinAge = Int(self.minAge.text ?? "0")!
            self.minAge.resignFirstResponder()
            return
        }
        
        if self.maxAge.isFirstResponder {
            valMaxAge = Int(self.maxAge.text ?? "0")!
            self.maxAge.resignFirstResponder()
            return
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
