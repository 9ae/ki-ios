//
//  DiscoveryWrapper.swift
//  iOSKinkedIn
//
//  Created by Alice on 3/1/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import SwiftUI

class DiscoveryWrapper: UIHostingController<AnyView> {
    
    @objc required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: AnyView(DiscoveryView()))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
