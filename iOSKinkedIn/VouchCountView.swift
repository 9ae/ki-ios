//
//  VouchCountView.swift
//  Discovery
//
//  Created by Alice Q Wong on 2/22/20.
//  Copyright © 2020 Alice Q Wong. All rights reserved.
//

import SwiftUI

struct VouchCountView: View {
    var count: Int
    var body: some View {
        let noun = "\(count > 1 ? "members" : "member")"
        return Text("vouched by\n\(count) \(noun)").font(.caption)
            .foregroundColor(Color.myPrimary)
            .lineLimit(2)
    }
}

struct VouchCountView_Previews: PreviewProvider {
    static var previews: some View {
        VouchCountView(count: 3)
    }
}

