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
    
    @IBOutlet var logoutBtn: UIButton!
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var basicInfo: UILabel!
    @IBOutlet var partnersContainer: UIView!
    
    @IBOutlet var genderTags: TagListView!
    @IBOutlet var roleTags: TagListView!
    @IBOutlet var kinksTags: TagListView!
    
    var me: Profile?
    var partners: [Profile] = []

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
        
        logoutBtn.backgroundColor = ThemeColors.action
        logoutBtn.titleLabel?.tintColor = UIColor.white
        logoutBtn.layer.cornerRadius =  15.0
        logoutBtn.clipsToBounds = true
        
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
        
        KinkedInAPI.partners { profiles in
            self.partners = profiles
            self.updatePartnersView()
        }
        
    }
    
    func updatePartnersView(){
        var leadingOffset: CGFloat = 8.0;
        for p in self.partners {
            
            guard let picture_id = p.picture_public_id else {
                continue
            }
            let url = "https://res.cloudinary.com/i99/image/upload/c_thumb,g_face,h_40,w_40/\(picture_id)"
            let imgURL = URL(string: url)
            
            do {
                let imgData = try Data(contentsOf: imgURL!)
                let picture = UIImageView.init(image: UIImage(data: imgData))
                picture.layer.cornerRadius = 20.0
                picture.clipsToBounds = true
                
                self.partnersContainer.addSubview(picture)
                
                picture.translatesAutoresizingMaskIntoConstraints = false
                picture.heightAnchor.constraint(equalToConstant: 40).isActive = true
                picture.widthAnchor.constraint(equalToConstant: 40).isActive = true
                picture.bottomAnchor.constraint(equalTo: self.partnersContainer.bottomAnchor, constant: 8).isActive = true
                picture.leadingAnchor.constraint(equalTo: self.partnersContainer.leadingAnchor, constant: leadingOffset).isActive = true
                
                leadingOffset += 30.0;
            } catch {
                continue
            }
            
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
        return 6
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let labelHeight: CGFloat = 30.0

        switch indexPath.row {
        case 1: return 100
        case 2: return genderTags.frame.height + labelHeight
        case 3: return roleTags.frame.height + labelHeight
        case 4: return kinksTags.bounds.height + labelHeight + 20
        default: return 300
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
        
        if segue.identifier == "editPartners",
            let vc = segue.destination as? PartnersVC {
            vc.partners = self.partners
        }
    }
    

}
