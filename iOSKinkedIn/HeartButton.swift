//
//  HeartButton.swift
//  Discovery
//
//  Created by Alice Q Wong on 2/22/20.
//  Copyright © 2020 Alice Q Wong. All rights reserved.
//

import SwiftUI

struct HeartButton: View {
    var size : CGFloat
    var action : () -> Void
    var body: some View {
        Button(action:action){
            Image(systemName: "heart.circle.fill")
                .resizable()
                .frame(width: size, height: size, alignment: .center)
                .foregroundColor(Color.myAction)
                .background(Color.white)
                .cornerRadius(size * 0.5 )
        }
    }
}

struct HeartButton_Previews: PreviewProvider {
    static var previews: some View {
        HeartButton(size: 50, action: {print("like")})
    }
}

