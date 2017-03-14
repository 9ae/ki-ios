//
//  ConnectionCell.swift
//  iOSKinkedIn
//
//  Created by alice on 3/11/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class ConnectionCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    func setProfilePicture(_ publicId: String){
        
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
