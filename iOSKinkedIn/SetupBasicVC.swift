//
//  SetupBasicVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import Toast_Swift

class SetupBasicVC: SetupViewVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var fieldName: UITextField?
    @IBOutlet var fieldBirthday: UIDatePicker?
    @IBOutlet weak var imagePicked: UIImageView!
    
    var imageUpdated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fieldName?.delegate = self
        
        let today = Date()
        var dc = DateComponents()
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        dc.year = -18
        fieldBirthday?.maximumDate = calendar.date(byAdding: dc, to: today)
        
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
        self.view.makeToast(message)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        var missing = [String]()
        if(identifier=="basic2genders"){
            if((fieldName?.text?.isEmpty)!){
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
        
        return false
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let image = self.imagePicked.image, let data = UIImageJPEGRepresentation(image, 1.0){
            print("Converted image to data of width:\(image.size.width)")
            let cloud = CloudNine(data)
            cloud.startUpload()
        } else {
            print("Unable to convert image")
        }

        var params = [String:Any]()
        
        if let name = fieldName?.text {
            params["name"] = name
        }
        
        if let birthday = fieldBirthday?.date, let calendar = fieldBirthday?.calendar {
            params["birthday"] = [
                "year": calendar.component(.year, from: birthday),
                "month": calendar.component(.month, from: birthday),
                "date": calendar.component(.day, from: birthday)
            ]
        }

        KinkedInAPI.updateProfile(params)
    }
    
}
