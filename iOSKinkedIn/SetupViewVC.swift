//
//  SetupViewVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/17/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class SetupViewVC: UIViewController {
    
    private var userToken: String?
    var requestParams: [String:Any] {
        get {
            return ["token": self.userToken!]

        }
    
    }
    
    func setToken(_ token: String) {
        self.userToken = token
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextScene = segue.destination as? SetupViewVC {
            nextScene.setToken(self.userToken!)
        }
    }

}
