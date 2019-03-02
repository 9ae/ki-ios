//
//  PictureVC.swift
//  iOSKinkedIn
//
//  Created by alice on 3/2/19.
//  Copyright © 2019 KinkedIn. All rights reserved.
//

import UIKit

class PictureVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var profile: Profile?
    @IBOutlet var defaultPicture: UIImageView!
    var imageUpdated = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let picUrl = profile?.picture {
            let imgurl = URL(string: picUrl)
            do {
                let imgData = try Data(contentsOf: imgurl!)
                defaultPicture.image = UIImage(data: imgData)
            } catch {
                // TODO: use put in place holder image
                print("error loading profile picture")
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changePicture(){
        self.prepareImagePicker()
    }
    
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
                self.profile?.picture = imageUrl
            }
            cloud.startUpload()
        } else {
            print("Unable to convert image")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
