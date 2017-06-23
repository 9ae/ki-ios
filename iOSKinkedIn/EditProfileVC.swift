//
//  EditProfileVC.swift
//  iOSKinkedIn
//
//  Created by alice on 6/20/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class EditProfileVC: UITableViewController {

    var me: Profile?
    @IBOutlet var defaultPicture: UIImageView!
    var imageUpdated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.makeToastActivity(.center)
        KinkedInAPI.myself { profile in
            self.me = profile
            print("profile loaded")
            self.updateTableWithInfo()
            self.view.hideToastActivity()
        }
    }

    func updateTableWithInfo(){
        
        let pictureCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
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
        } else {
            pictureCell?.backgroundColor = UIColor.red
        }
        
        let basicCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0))
        if((me?.hasName())! && (me?.hasAge())! && me?.birthday != nil){
            basicCell?.backgroundColor = UIColor.white
            basicCell?.textLabel?.text = "\(me?.name ?? "Name"), \(me?.age ?? 0)"
        } else {
            basicCell?.backgroundColor = UIColor.red
        }
        
        let gendersCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0))
        if((me?.genders.count ?? 0) > 0){
            gendersCell?.backgroundColor = UIColor.white
        } else {
            gendersCell?.backgroundColor = UIColor.red
        }
        gendersCell?.detailTextLabel?.text = shortJoin((me?.genders ?? [String]()))
        
        let rolesCell = tableView.cellForRow(at: IndexPath(row: 3, section: 0))
        if((me?.roles.count ?? 0) > 0){
            rolesCell?.backgroundColor = UIColor.white
        } else {
            rolesCell?.backgroundColor = UIColor.red
        }
        rolesCell?.detailTextLabel?.text = shortJoin((me?.roles ?? [String]()))
        
        let kinksCell = tableView.cellForRow(at: IndexPath(row: 4, section: 0))
        if((me?.kinks.count ?? 0) > 0){
            kinksCell?.backgroundColor = UIColor.white
        } else {
            kinksCell?.backgroundColor = UIColor.red
        }
        kinksCell?.detailTextLabel?.text = shortJoin((me?.kinks ?? [String]()))
        
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
        return 7
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.row){
        case 0:
            self.prepareImagePicker()
        case 1:
            self.performSegue(withIdentifier: "editBasic", sender: self)
        case 2:
            self.performSegue(withIdentifier: "editGenders", sender: self)
        case 3:
            self.performSegue(withIdentifier: "editRoles", sender: self)
        case 4:
            self.performSegue(withIdentifier: "editKinks", sender: self)
        case 5:
            print("editBio")
        case 6:
            self.performSegue(withIdentifier: "myPartners", sender: self)
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
        if(segue.identifier == "editBasic"){
            if let vc = segue.destination as? BasicProfileVC {
                vc.name = me?.name
                vc.birthday = me?.birthday
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
            cloud.startUpload()
        } else {
            print("Unable to convert image")
        }
    }
}
