//
//  BaseProfileVC.swift
//  iOSKinkedIn
//
//  Created by alice on 9/8/18.
//  Copyright © 2018 KinkedIn. All rights reserved.
//

import UIKit

class BaseProfileVC: UIViewController {
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var basicInfo: UILabel!
    
    private var _profile: Profile?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let profile = _profile else {
            return
        }
        
        if let pictureURL = profile.picture {
            let imgURL = URL(string: pictureURL)
            do {
                let imgData = try Data(contentsOf: imgURL!)
                profileImage.image = UIImage(data: imgData)
            } catch {
                // TODO: use put in place holder image
                print("ERR loading profile picture")
            }
        }
        
        var basicText = "\(profile.name), \(profile.age)"
        if let _city = profile.city {
            basicText += "\n\(_city)"
        }
        basicInfo.text = basicText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setContent(_ profile: Profile){
        self._profile = profile
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
