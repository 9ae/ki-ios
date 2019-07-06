//
//  VouchIntroVC.swift
//  iOSKinkedIn
//
//  Created by alice on 5/2/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import Atributika

class VouchIntroVC: UIViewController {
    
    var subjectName: String?
    var subjectUUID: String?
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var catchText: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        goButton.setTitle("Yes, I feel qualified to vouch for \(subjectName!)?", for: UIControl.State.normal)
        
        let catchWording = "Your feedback will not negatively affect \(subjectName!)'s reputation, but if you need to talk to someone about your experience with \(subjectName!), you can do that <a>here.</a>"
        
        let a = Style("a", style: Style.foregroundColor(Color.blue)).underlineStyle(NSUnderlineStyle.single)
        let catchStyles = catchWording.style(tags: [a])
        
        catchText.attributedText = catchStyles.attributedString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let vouchVC = segue.destination as? VouchVC {
            vouchVC.subjectName = subjectName
            vouchVC.subjectUUID = subjectUUID
        }
    }
    

}
