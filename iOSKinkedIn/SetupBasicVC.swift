//
//  SetupBasicVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class SetupBasicVC: SetupViewVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePicked: UIImageView!
    var basicVC: BasicProfileVC?
    
    var imageUpdated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func selectPhoto(_sender: AnyObject) {
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
            self.imagePicked.image = selectImage
            self.imageUpdated = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func missingFields(_ missing: [String]){
        let message = "Please provide us with your: "+missing.joined(separator: ", ")
        self.alert(message, title: "Missing Info")
    }
 
  
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if(identifier=="basic2kinks"){
            var missing = [String]()
            if let isName = basicVC?.isNameSet() {
                print(isName)
            } else {
                missing.append("preferred name")
            }
            
            if(!imageUpdated) {
                missing.append("profile picture")
            }
            
            if(missing.count>0){
                missingFields(missing)
                return false
            } else {
                return true
            }
        }
        
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == "proBasicCreate"){
            basicVC = segue.destination as? BasicProfileVC
        } else if(segue.identifier == "basic2kinks") {
            if let image = self.imagePicked.image, let data = UIImageJPEGRepresentation(image, 1.0){
                print("Converted image to data of width:\(image.size.width)")
                let cloud = CloudNine(data)
                cloud.startUpload()
            } else {
                print("Unable to convert image")
            }
            basicVC?.post()
        }
        
        

    }

}
