//
//  ViewProfileVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/26/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

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
    
    static let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
    var blurEffectView = UIVisualEffectView(effect: blurEffect)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imgURL = URL(string: "https://www.trykinkedin.com/temp/arden3.jpg")
        do {
            let imgData = try Data(contentsOf: imgURL!)
            let img = UIImage(data: imgData)
            self.profilePicture?.image = img
        } catch {
            // TODO: use put in place holder image
        }
        
        readLess?.isHidden = true
        self.blurEffectView.frame = self.view.bounds
        self.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showBio(_ sender: AnyObject) {
        readMore?.isHidden = true
        fadeGradient?.isHidden = true
        self.readMore?.isEnabled = false
        
        let screenHeight = self.view.frame.size.height - 40
        self.bioExcerpt?.frame.size.height = screenHeight - 15
        
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
    
    @IBAction func hideBio(_ sender: AnyObject) {
        self.readLess?.isHidden = true
        self.readLess?.isEnabled = false
        
        UIView.animate(withDuration: 1, animations: {
            self.blurEffectView.alpha = 0
            self.bioTab?.alpha = 1.0
            
            
        }) { finished in
            
            UIView.animate(withDuration: 2, animations: {
                self.bioTab?.frame.origin.y = 400
            }){
                finished in
                self.fadeGradient?.isHidden = false
                self.readMore?.isHidden = false
                self.readMore?.isEnabled = true
            }
        }
    }
    
    @IBAction func like(_ sender: AnyObject) {
    
    }
    
    @IBAction func hide(_ sender: AnyObject) {}
    
    @IBAction func skip(_ sender: AnyObject) {}

}
