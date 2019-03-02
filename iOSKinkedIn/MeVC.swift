//
//  MeVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/17/19.
//  Copyright © 2019 KinkedIn. All rights reserved.
//

import UIKit
import TagListView

class MeVC: UITableViewController {
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var basicInfo: UILabel!
    
    @IBOutlet var genderTags: TagListView!
    @IBOutlet var roleTags: TagListView!
    @IBOutlet var kinksTags: TagListView!
    
    var me: Profile?

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
        
        self.view.makeToastActivity(.center)
        KinkedInAPI.myself { profile in
            self.view.hideToastActivity()
            self.updateContent(profile)
        }
        
    }
    
    func updateContent(_ profile: Profile){
        self.me = profile
        if let pictureURL = profile.picture {
            let imgURL = URL(string: pictureURL)
            do {
                let imgData = try Data(contentsOf: imgURL!)
                self.profileImage.image = UIImage(data: imgData)
            } catch {
                // TODO: use put in place holder image
                print("ERR loading profile picture")
            }
        }
        
        var basicText = "\(profile.name), \(profile.age)"
        if let city = profile.city {
            basicText += "\n\(city)"
        }
        basicInfo.text = basicText
        
        for g in profile.genders { genderTags.addTag(g) }
        for r in profile.roles { roleTags.addTag(r) }
        for k in profile.kinks { kinksTags.addTag(k.label) }
 
    }
    
    @IBAction func logout(_ sender: Any){
        KinkedInAPI.logout()
        KeychainWrapper.standard.removeObject(forKey: "kiToken")
        self.performSegue(withIdentifier: "logout2auth", sender: sender)
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
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let labelHeight: CGFloat = 30.0

        switch indexPath.row {
        case 1: return genderTags.frame.height + labelHeight
        case 2: return roleTags.frame.height + labelHeight
        case 3: return kinksTags.bounds.height + labelHeight + 20
        default: return 400
        }
        
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 1: return tableView.dequeueReusableCell(withIdentifier: "biogenders", for: indexPath)
            case 2: return tableView.dequeueReusableCell(withIdentifier: "bioroles", for: indexPath)
            case 3: return tableView.dequeueReusableCell(withIdentifier: "biokinks", for: indexPath)
            default : return tableView.dequeueReusableCell(withIdentifier: "biobasics", for: indexPath)
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bioprompt", for: indexPath)
        
        if let _promptCell = cell as? PromptCell,
            let prompts = self.me?.prompts {
            let prompt = prompts[indexPath.row]
            _promptCell.setContent(prompt)
        }
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
        if segue.identifier == "editBasic",
            let vc = segue.destination as? BasicProfileVC  {
                vc.profile = me
        }
        
        if segue.identifier == "editGenders",
            let vc = segue.destination as? GendersVC {
                vc.profile = me
        }
        
        if segue.identifier == "editRoles",
            let vc = segue.destination as? RolesVC {
            vc.profile = me
        }
        
        if segue.identifier == "editKinks",
            let vc = segue.destination as? KinksVC {
            vc.profile = me
        }
        
        if segue.identifier == "editPrompts",
            let vc = segue.destination as? PromptVC {
            vc.profile = me
        }
        
        if segue.identifier == "editPicture",
            let vc = segue.destination as? PictureVC {
            vc.profile = me
        }
    }
    

}
