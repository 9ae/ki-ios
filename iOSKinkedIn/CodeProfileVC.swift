//
//  CodeProfileVC.swift
//  iOSKinkedIn
//
//  Created by alice on 9/15/18.
//  Copyright © 2018 KinkedIn. All rights reserved.
//

import UIKit

class CodeProfileVC: UIViewController {
    
    private var profileImage: UIImageView
    private var content: AngleView
//    private var basicInfo: UILabel
//    private var countKinksMatched: UILabel
//    private var countVouchedBy: UILabel
//    private var identies: TagListView
    
    var profile: Profile
    
    init(_ profile: Profile) {
        self.profile = profile
        
        profileImage = UIImageView()
        content = AngleView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        content.backgroundColor = UIColor.clear
        
        self.setConstraints()
        
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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setConstraints() {
        view.addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 360).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        view.addSubview(content)
        
        content.translatesAutoresizingMaskIntoConstraints = false
        content.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 280).isActive = true
        content.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        content.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        content.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true

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
