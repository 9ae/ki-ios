//
//  UserCell.swift
//  iOSKinkedIn
//
//  Created by Alice Q Wong on 11/7/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    func set(_ publicId: String, _ name: String){
        self.name.text = name
        let url = "https://res.cloudinary.com/i99/image/upload/c_thumb,g_face,h_120,w_120/\(publicId)"
        let imgURL = URL(string: url)
        do {
            let imgData = try Data(contentsOf: imgURL!)
            let img = UIImage(data: imgData)
            self.picture?.image = img
        } catch {
            // TODO: use put in place holder image
            print("error loading profile picture")
        }
    }

}
