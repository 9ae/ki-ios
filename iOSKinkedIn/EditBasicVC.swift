//
//  EditBasicVC.swift
//  iOSKinkedIn
//
//  Created by alice on 6/19/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class EditBasicVC: UIViewController {
    
    var content: BasicProfileVC?
    var name: String?
    var birthday: Date?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool){
        print("goes back")
        content?.post()
        super.viewWillDisappear(animated)
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "proBasicEdit"){
            content = segue.destination as? BasicProfileVC
            print("subview loaded")
            content?.update(name: name!, birthday: birthday!)
        }
    }
    

}
