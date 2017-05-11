//
//  hyp.swift
//  iOSKinkedIn
//
//  Created by alice on 5/4/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation
import HyphenateLite

class Hyp {

    static func start(){
        KinkedInAPI.messageLogin { (username, password ) in
            let client = EMClient.shared()
            let error = client?.login(withUsername: username, password: password)
            if(error != nil){
                print("HYP login failed")
            } else {
                client?.options.isAutoLogin = true
                print("HYP login successful")
            }
        }
    }

}
