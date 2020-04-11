//
//  BioVC.swift
//  iOSKinkedIn
//
//  Created by Alice on 4/11/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import UIKit

class BioVC: UIViewController {
    
    @IBOutlet weak var textarea: UITextView!
    
    var bioText : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        textarea.layer.cornerRadius = 8.0
        textarea.clipsToBounds = true
        textarea.backgroundColor = UIColor.white
        textarea.textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        textarea.text = bioText ?? ""
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateBio()
    }
    
    func updateBio(){
        KinkedInAPI.updateProfile(["bio": textarea.text])
    }
    
    @IBAction func onSave(_ sender: Any){
        updateBio()
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
