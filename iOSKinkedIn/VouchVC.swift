//
//  VouchVC.swift
//  iOSKinkedIn
//
//  Created by alice on 5/3/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class VouchVC: UIViewController {
    
    var subjectName: String?
    var subjectUUID: String?
    
    var answers = [
        "communicate": true,
        "honest": true,
        "respect": true
    ]
    
    @IBOutlet weak var q1label: UILabel!
    @IBOutlet weak var q1no: ReverseButton!
    @IBOutlet weak var q1yes: ReverseButton!

    
    @IBOutlet weak var q2label: UILabel!
    @IBOutlet weak var q2no: ReverseButton!
    @IBOutlet weak var q2yes: ReverseButton!
    
    
    @IBOutlet weak var q3label: UILabel!
    @IBOutlet weak var q3no: ReverseButton!
    @IBOutlet weak var q3yes: ReverseButton!
    
    @IBOutlet weak var confirmLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Vouch for \(subjectName!)"

        q1label.text = "Was \(subjectName!) the same person they showed in their profile?"
        
        q2label.text = "Was \(subjectName!) respectful of your boundaries?"
        
        q3label.text = "Was \(subjectName!) an honest communicator?"
        
        confirmLabel.text = "By submitting, you are confirming that the feedback you provide is based on your interactions with \(subjectName!)."
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onNoQ1(_ sender: Any) {
        q1yes.reverseColors()
        answers["honest"] = false
    }

    @IBAction func onYesQ1(_ sender: Any) {
        q1no.reverseColors()
        answers["honest"] = true
    }
    
    @IBAction func onNoQ2(_ sender: Any) {
        q2yes.reverseColors()
        answers["respect"] = false
    }
    
    
    @IBAction func onYesQ2(_ sender: Any) {
        q2no.reverseColors()
        answers["respect"] = true
    }
    
    @IBAction func onNoQ3(_ sender: Any) {
        q3yes.reverseColors()
        answers["communicate"] = false
    }
    
    @IBAction func onYesQ3(_ sender: Any) {
        q3no.reverseColors()
        answers["communicate"] = true
    }
    
    
    @IBAction func onSubmit(_ sender: Any) {
        
        if(subjectUUID != nil){
            KinkedInAPI.vouch(subjectUUID!, answers: answers)
            self.performSegue(withIdentifier: "vouch2connect", sender: sender)
        }
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
