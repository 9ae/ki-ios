//
//  KinksCountView.swift
//  Discovery
//
//  Created by Alice Q Wong on 2/22/20.
//  Copyright © 2020 Alice Q Wong. All rights reserved.
//

import SwiftUI

struct KinksCountView: View {
    var count : Int
    var body: some View {
        let noun = count > 1 ? "kinks" : "kink"
        return Text("\(count) \(noun)\n matched")
            .font(.caption)
            .foregroundColor(Color.myPrimary)
            .lineLimit(2)
        
    }
}

struct KinksCountView_Previews: PreviewProvider {
    static var previews: some View {
        KinksCountView(count: 2)
    }
}

