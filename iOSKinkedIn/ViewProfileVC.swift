//
//  ViewProfileVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/26/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import Atributika

class ViewProfileVC: UIViewController {
    
    @IBOutlet var profilePicture : UIImageView?
    @IBOutlet var preferredName: UILabel?
    @IBOutlet var kinksCount: UILabel?
    @IBOutlet var shortBio: UILabel?
    @IBOutlet var bioExcerpt: UITextView?
    @IBOutlet var readMore: UIButton?
    @IBOutlet var fadeGradient: UIView?
    @IBOutlet var bioTab: UIView?
    @IBOutlet var readLess: UIButton?
    
    @IBOutlet var likeUser: UIButton?
    @IBOutlet var skipUser: UIButton?
    
    static let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
    var blurEffectView = UIVisualEffectView(effect: blurEffect)
    
    var likeBtnOrigin = CGPoint()
    var skipBtnOrigin = CGPoint()

    var profile: Profile?
    
    var isReadOnly = false

    override func viewDidLoad() {
        super.viewDidLoad()
        bioTab?.isHidden = true
        enableActions(false)
        
        readLess?.isHidden = true
        self.blurEffectView.frame = self.view.bounds
        self.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        likeBtnOrigin = (self.likeUser?.frame.origin)!
        skipBtnOrigin = (self.skipUser?.frame.origin)!
        
        let swipeUpRecog = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp))
        swipeUpRecog.direction = .up
        swipeUpRecog.numberOfTouchesRequired = 1
        
        bioTab?.addGestureRecognizer(swipeUpRecog)
    }
    
    func enableActions(_ enable: Bool){
        likeUser?.isHidden = !enable
        likeUser?.isEnabled = enable
        skipUser?.isHidden = !enable
        skipUser?.isEnabled = enable
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setProfile(_ profile: Profile){
        self.profile = profile
        
        self.preferredName?.text = profile.name
        
        self.kinksCount?.text = "\(profile.kinksMatched) kinks matched".uppercased()
        
         let b = Style("b")
            .foregroundColor(ThemeColors.primaryDark)
         var shortBioText = "<b>\(profile.age)</b> years old"
        
        if let city = profile.city {
            shortBioText += ", living in <b>\(city)</b>"
        }
        if profile.genders.count > 0 {
            var joined = profile.genders.joined(separator: ", ")
            joined = joined.lowercased()
            shortBioText += "\nIdentifies as: "+joined
        }
        
        let shortBioAS = shortBioText.style(tags: b)
        shortBio?.attributedText = shortBioAS.attributedString
        
        
        if let pictureURL = self.profile?.picture {
            let imgURL = URL(string: pictureURL)
            do {
                let imgData = try Data(contentsOf: imgURL!)
                let img = UIImage(data: imgData)
                self.profilePicture?.image = img
            } catch {
                // TODO: use put in place holder image
                print("error loading profile picture")
            }
        }
        
        var bioText = ""
        if (!profile.kinks.isEmpty){
            let kinks : [String] = profile.kinkLabels()
            bioText = "I am into " + kinks.joined(separator: ", ")
            /*
            var kinksDetail = [String]()
            for i in (0...5){
                let llv = profile.kinks[i]
                if(llv.isEmpty){
                    continue
                }
                let desc = experiences[i] + ": " + llv.joined(separator: ", ")
                kinksDetail.append(desc)
            }
            if (!kinksDetail.isEmpty){
                bioText = kinksDetail.joined(separator: "\n\n") + "\n\n\n"
            }
            */
            bioText += "\n\n\n"
        }
        bioText += profile.bio!
        bioExcerpt?.text = bioText
        
        bioTab?.isHidden = false
        if(!isReadOnly){
            enableActions(true)
        }
        NotificationCenter.default.post(name: NOTIFY_PROFILE_LOADED, object: nil)
    }
    
    private func _buttonsBounceUp(){
        // TODO: Add bounce
        if likeUser?.isHidden ?? true {
            return
        }
        likeUser?.frame.origin.y = 2
        skipUser?.frame.origin.y = 2
        
    }
    
    private func _buttonsBounceBack() {
        if likeUser?.isHidden ?? true {
            return
        }
        likeUser?.frame.origin = likeBtnOrigin
        skipUser?.frame.origin = skipBtnOrigin
        
    }
    
    private func _animateUp(finished: Bool){
        // TODO: Make sure this is the correct way to chain animations
        let screenHeight = self.view.frame.size.height - 40
        self.bioExcerpt?.frame.size.height = screenHeight - 15
        if(self.blurEffectView.superview == nil) { // first time animating up
            self.likeBtnOrigin.x = self.likeUser?.frame.origin.x ?? 0
            self.skipBtnOrigin.x = self.skipUser?.frame.origin.x ?? 0
        }
        
        UIView.animate(
            withDuration: 3,
            animations: {
                if let frame = self.bioTab?.frame {
                    self.bioTab?.frame = CGRect(
                        x: frame.origin.x,
                        y: 10,
                        width: frame.size.width,
                        height: screenHeight
                    )
                }
                
        },
            completion: { finished in
                if(finished){
                    if(self.blurEffectView.superview == nil){
                        self.profilePicture?.addSubview(self.blurEffectView)
                        print("add effect")
                    } else {
                        self.blurEffectView.alpha = 1.0
                        print("make effect visible")
                    }
                    
                    self.bioTab?.alpha = 0.69
                    
                    self.readLess?.isHidden = false
                    self.readLess?.isEnabled = true
                }
        }
        )
    }
    
    private func _nextProfile(_ action: ActionOnUser){
        NotificationCenter.default.post(name: NOTIFY_NEXT_PROFILE, object: action)
    }
    
    @IBAction func showBio(_ sender: AnyObject) {
        readMore?.isHidden = true
        fadeGradient?.isHidden = true
        self.readMore?.isEnabled = false
        
        self.bioExcerpt?.heightAnchor.constraint(equalToConstant: self.view.frame.size.height - 200)
        
        self.bioExcerpt?.isScrollEnabled = true
        self.bioExcerpt?.showsVerticalScrollIndicator = true
        
        UIView.animate(withDuration: 1, animations: _buttonsBounceUp, completion: _animateUp)
    }
    
    @IBAction func hideBio(_ sender: AnyObject) {
        self.readLess?.isHidden = true
        self.readLess?.isEnabled = false
        
        self.bioExcerpt?.isScrollEnabled = false
        self.bioExcerpt?.showsVerticalScrollIndicator = false
        
        UIView.animate(withDuration: 1, animations: {
            self.bioTab?.alpha = 1.0
            
            
        }) { finished in
            self.blurEffectView.alpha = 0
            UIView.animate(withDuration: 2, animations: {
                self.bioTab?.frame.origin.y = 400
            }){
                finished in
                self.fadeGradient?.isHidden = false
                self.readMore?.isHidden = false
                self.readMore?.isEnabled = true
                UIView.animate(withDuration: 1, animations: self._buttonsBounceBack)
            }
        }
    }
    
    @IBAction func like(_ sender: AnyObject) {
        
        guard let uuid = self.profile?.neoId else {
            return
        }
        
        KinkedInAPI.likeProfile(uuid) { reciprocal in
        }

    }

    
    @IBAction func skip(_ sender: AnyObject) {
        guard let uuid = self.profile?.neoId else {
            return
        }
        KinkedInAPI.skipProfile(uuid)
        _nextProfile(.skip)
    }
    
    @objc func swipedUp(recog: UISwipeGestureRecognizer) {
        showBio(recog)
    }

}
