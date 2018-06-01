//
//  EditProfileVC.swift
//  iOSKinkedIn
//
//  Created by alice on 6/20/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

enum ProfileDetailSegue : String {
    case basic = "editBasic"
    case genders = "editGenders"
    case roles = "editRoles"
    case kinks = "editKinks"
    case bio = "editBio"
}

enum ProfileDetailRow : Int {
    case picture = 0
    case basic = 1
    case genders = 2
    case roles = 3
    case kinks = 4
    case bio = 5
}

class EditProfileVC: UITableViewController {

    var me: Profile?
    @IBOutlet var defaultPicture: UIImageView!
    var imageUpdated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.makeToastActivity(.center)
        KinkedInAPI.myself { profile in
            self.me = profile
            self.updateTableWithInfo()
            self.view.hideToastActivity()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addTopSpace()
        if(me != nil){
            updateTableWithInfo()
        }
    }
    
    func incompleteStyle(_ view: UITableViewCell){
        let layer = view.layer
        layer.borderColor = ThemeColors.no.cgColor
        layer.borderWidth = 2.0
        view.textLabel?.textColor = ThemeColors.no
    }
    
    func completeStyle(_ view: UITableViewCell){
         let layer = view.layer
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
        view.textLabel?.textColor = UIColor.black
    }

    func updateTableWithInfo(){
        
        let pictureCell = tableView.cellForRow(at: IndexPath(row: ProfileDetailRow.picture.rawValue, section: 0))
        if(me?.picture != nil){
            pictureCell?.backgroundColor = UIColor.white
            let imgURL = URL(string: (me?.picture)!)
            do {
                let imgData = try Data(contentsOf: imgURL!)
                defaultPicture.image = UIImage(data: imgData)
            } catch {
                // TODO: use put in place holder image
                print("error loading profile picture")
            }
            completeStyle(pictureCell!)
        } else {
            incompleteStyle(pictureCell!)
        }
        
        let basicCell = tableView.cellForRow(at: IndexPath(row: ProfileDetailRow.basic.rawValue, section: 0))
        if((me?.hasName())! && (me?.hasAge())! && me?.birthday != nil){
            basicCell?.backgroundColor = UIColor.white
            basicCell?.textLabel?.text = "\(me?.name ?? "Name"), \(me?.age ?? 0) years old, \((me?.exp ?? "experience with")) BDSM"
            completeStyle(basicCell!)
        } else {
            incompleteStyle(basicCell!)
        }
        
        let gendersCell = tableView.cellForRow(at: IndexPath(row: ProfileDetailRow.genders.rawValue, section: 0))
        if((me?.genders.count ?? 0) > 0){
            gendersCell?.backgroundColor = UIColor.white
            completeStyle(gendersCell!)
        } else {
            incompleteStyle(gendersCell!)
        }
        gendersCell?.detailTextLabel?.text = shortJoin((me?.genders ?? [String]()))
        
        let rolesCell = tableView.cellForRow(at: IndexPath(row: ProfileDetailRow.roles.rawValue, section: 0))
        rolesCell?.detailTextLabel?.text = shortJoin((me?.roles ?? [String]()))
        
        let kinksCell = tableView.cellForRow(at: IndexPath(row: ProfileDetailRow.kinks.rawValue, section: 0))
        if((me?.kinks.count ?? 0) > 0){
            kinksCell?.backgroundColor = UIColor.white
            completeStyle(kinksCell!)
        } else {
            incompleteStyle(kinksCell!)
        }
        kinksCell?.detailTextLabel?.text = shortJoin((me?.kinkLabels() ?? [String]()))
        
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let complete = me?.setup_complete, section == 0{
            if(complete){
                return "Your profile is published!"
            } else {
                return "Please complete highlighted fields"
            }
        }
        return nil
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.row){
        case ProfileDetailRow.picture.rawValue:
            self.prepareImagePicker()
        case ProfileDetailRow.basic.rawValue:
            self.performSegue(withIdentifier: ProfileDetailSegue.basic.rawValue, sender: self)
        case ProfileDetailRow.genders.rawValue:
            self.performSegue(withIdentifier: ProfileDetailSegue.genders.rawValue, sender: self)
        case ProfileDetailRow.roles.rawValue:
            self.performSegue(withIdentifier: ProfileDetailSegue.roles.rawValue, sender: self)
        case ProfileDetailRow.kinks.rawValue:
            self.performSegue(withIdentifier: ProfileDetailSegue.kinks.rawValue, sender: self)
        case ProfileDetailRow.bio.rawValue:
            self.performSegue(withIdentifier: ProfileDetailSegue.bio.rawValue, sender: self)
        default:
            print("do nothing")
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == ProfileDetailSegue.basic.rawValue){
            if let vc = segue.destination as? BasicProfileVC {
                vc.profile = me
            }
        }
        
        if(segue.identifier == ProfileDetailSegue.genders.rawValue){
            if let vc = segue.destination as? GendersVC {
                vc.profile = me
            }
        }
        
        if(segue.identifier == ProfileDetailSegue.roles.rawValue){
            if let vc = segue.destination as? RolesVC {
                vc.profile = me
            }
        }
        
        if(segue.identifier == ProfileDetailSegue.kinks.rawValue){
            if let vc = segue.destination as? KinksVC {
                vc.profile = me
            }
        }
        
        if(segue.identifier == ProfileDetailSegue.bio.rawValue){
            if let vc = segue.destination as? PromptVC {
                vc.profile = me
            }
        }
    }

}

extension EditProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func prepareImagePicker(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: false, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: false) {
            //UIImagePickerControllerReferenceURL
            var selectImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
            selectImage = selectImage?.scaledTo(width: 375.0)
            self.defaultPicture.image = selectImage
            self.imageUpdated = true
            self.uploadImage()
        }
        
    }
    
    func uploadImage(){
        if let image = self.defaultPicture.image, let data = UIImageJPEGRepresentation(image, 1.0){
            print("Converted image to data of width:\(image.size.width)")
            let cloud = CloudNine(data)
            cloud.completionHandler = { imageUrl in
                self.me?.picture = imageUrl
            }
            cloud.startUpload()
        } else {
            print("Unable to convert image")
        }
    }
}
