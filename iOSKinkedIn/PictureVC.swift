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
        
        if let picUrl = profile?.pictures[0] {
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
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: false, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: false) {
            // TODO put in image cropper
            var selectImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
            selectImage = selectImage?.scaledTo(width: 350.0)
            self.defaultPicture.image = selectImage
            self.imageUpdated = true
            self.uploadImage()
        }
        
    }
    
    func uploadImage(){
        if let image = self.defaultPicture.image, let data = image.jpegData(compressionQuality: 1.0) {
            print("Converted image to data of width:\(image.size.width)")
            KinkedInAPI.uploadPicture(data: data.base64EncodedString())
        } else {
            print("Unable to convert image")
        }
    }
    
    @IBAction
    func openWebapp(_ sender : Any) {
        // "http://localhost:5000/web/my/upload?token=\(KinkedInAPI.token)"
        if let url = URL(string: "https://api-mistress.kinkedin.app/web/my/upload?token=\(KinkedInAPI.token)") {
            print("open in safari")
            UIApplication.shared.open(url, options: [:])
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
