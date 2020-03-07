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
        let view = DiscoveryView().environmentObject(Dungeon.shared)
            //EnvView().environmentObject(Widow())
       // super.init(coder: aDecoder, rootView: view)
       super.init(coder: aDecoder, rootView: AnyView(view))
        
    }

}
