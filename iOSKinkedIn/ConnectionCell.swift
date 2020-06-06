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
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var lastMsg: UILabel!
    
    private func setProfilePicture(_ url: String){
        
        let imgURL = URL(string: url)
        do {
            let imgData = try Data(contentsOf: imgURL!)
            let img = UIImage(data: imgData)
            self.picture.image = img
            self.picture.clipsToBounds = true
            self.picture.layer.cornerRadius = self.picture.frame.width * 0.5
        } catch {
            // TODO: use put in place holder image
            print("error loading profile picture")
        }
    }
    
    func setData(_ profile : Profile){
        self.name.text = profile.name
        
        if let th_url = profile.th_picture {
            self.setProfilePicture(th_url)
        } else {
            self.picture.image = UIImage(systemName: "icloud")
        }
        
        if let convo = profile.convo {
            lastMsg.text = convo.text
            lastMsg.isHidden = false
        }
    }
}
