//
//  DiscoverProfile.swift
//  iOSKinkedIn
//
//  Created by alice on 5/22/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import Atributika

class DiscoverProfile: UIViewController, UITextViewDelegate {
    
    @IBOutlet var kinks: UILabel!
    @IBOutlet var vouches: UILabel!
    @IBOutlet var shortBio: UILabel!
    @IBOutlet var longBio: UITextView!
    @IBOutlet var picture: UIImageView!
    @IBOutlet var kinksBio: UILabel!
    
    private var _profile: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // longBio.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.alpha = 0.89
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        guard let profile = _profile else {
            return
        }
        
        if let pictureURL = profile.picture {
            let imgURL = URL(string: pictureURL)
            do {
                let imgData = try Data(contentsOf: imgURL!)
                picture.image = UIImage(data: imgData)
            } catch {
                // TODO: use put in place holder image
                print("error loading profile picture")
            }
        }
        
        kinks.text = "\(profile.kinksMatched) kinks matched"
        if profile.vouches > 0 {
            vouches.text = "vouched by \(profile.vouches) users"
        } else {
            vouches.isHidden = true
        }
        
        let baseStyle = Style().foregroundColor(ThemeColors.text)
        
        let b = Style("b")
            .foregroundColor(ThemeColors.primaryDark)
        var shortBioText = "<b>\(profile.age)</b> years old"
        
        if let city = profile.city {
            shortBioText += ", living in <b>\(city)</b>"
        }
        if profile.genders.count > 0 {
            let genders = profile.genders.map({ (str) -> String in
                return "<b>\(str)</b>"
            })
            var joined = genders.joined(separator: ", ")
            joined = joined.lowercased()
            shortBioText += "\nIdentifies as: "+joined
        }
        
        //shortBioText = "<p>"+shortBioText+"</p>"
        
        let shortBioAS = shortBioText.style(tags: b).styleAll(baseStyle)
        shortBio?.attributedText = shortBioAS.attributedString
        
        let i = Style("i").obliqueness(0.2)
        
        if (!profile.kinks.isEmpty) {
            let kinksText = profile.kinks.map{ki in ki.label}
            let kinksAttr = ("<i>Kinks I like</i>\n" + kinksText.joined(separator: ", ")).style(tags: i).styleAll(baseStyle)
            kinksBio.attributedText = kinksAttr.attributedString
            kinksBio.isHidden = false
        } else {
            kinksBio.isHidden = true
        }
        
        if let prompts = profile.prompts {
            let questions = prompts.map({ p -> String in
                return "<i>\(p.title)</i>\n \(p.answer ?? "")"
            })
            let bioText = (questions.joined(separator: "\n\n")).style(tags: i).styleAll(baseStyle)
            longBio.attributedText = bioText.attributedString
        } else {
            longBio.attributedText = NSAttributedString(string: "", attributes: [:])
        }
        
    }
    
    func setProfile(_ profile: Profile, isDiscoverMode: Bool = true){
        self._profile = profile
        
        self.setTitleToAll(profile.name)
        
        if(!isDiscoverMode){
            self.navigationItem.setRightBarButtonItems([], animated: false)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("on scroll")
    }
    */
    private func back(){
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func like(_ sender: AnyObject) {
        
        guard let uuid = self._profile?.neoId else {
            return
        }
        
        KinkedInAPI.likeProfile(uuid) { reciprocal in
            if(reciprocal) {
                NotificationCenter.default.post(name: NOTIFY_RECIPROCAL_FEEFEE, object: nil)
            }
        }
        back()
        
    }
    
    
    @IBAction func skip(_ sender: AnyObject) {
        guard let uuid = self._profile?.neoId else {
            return
        }
        KinkedInAPI.skipProfile(uuid)
        back()
        
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
