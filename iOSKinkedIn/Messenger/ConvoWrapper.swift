//
//  ConvoWrapper.swift
//  iOSKinkedIn
//
//  Created by Alice on 1/25/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import UIKit
import SwiftUI
// import SendBirdSDK

@available(iOS 13.0.0, *)
class ConvoWrapper: UIHostingController<ConvoUI> {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: ConvoUI(profile: mockProfile))
    }
    
    init(_ profile: Profile) {
        /*
        SBDGroupChannel.createChannel(withUserIds: [profile.uuid], isDistinct: true) { (_chan, _error) in
            <#code#>
        }
        */
        
        super.init(rootView: ConvoUI(profile: profile))
    }
}
