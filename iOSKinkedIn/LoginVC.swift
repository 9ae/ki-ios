//
//  LoginVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import RealmSwift

class LoginVC: UIViewController {
    
    @IBOutlet var fieldEmail: UITextField?
    @IBOutlet var fieldPassword: UITextField?
    
    var loginBtnSender: AnyObject?
    var userNeoId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: AnyObject){
        loginBtnSender = sender
        if let email = fieldEmail?.text,
            let password = fieldPassword?.text {
            KinkedInAPI.login(email: email, password: password, callback: checkProfileCreated)
            
        }
        
    }
    
    func checkProfileCreated(_ neoId: String) {
        userNeoId = neoId
        if ((Profile.get(neoId)) != nil){
            //TODO api:#2 we shoud really validate with the server instead locally
            self.performSegue(withIdentifier: "login2app", sender: loginBtnSender!)
        } else {
            self.performSegue(withIdentifier: "login2setup", sender: loginBtnSender!)
        }
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="login2setup"){
            let setupView = segue.destination as? SetupPageNC
            setupView?.userNeoId = userNeoId
        }
    }
    

}
