//
//  NextButton.swift
//  Discovery
//
//  Created by Alice Q Wong on 2/22/20.
//  Copyright © 2020 Alice Q Wong. All rights reserved.
//

import SwiftUI

struct NextButton: View {
    var size : CGFloat
    var action : () -> Void
    var body: some View {
        Button(action:action){
            Image(systemName: "arrowshape.turn.up.right.circle.fill")
                .resizable()
                .frame(width: size, height: size, alignment: .center)
                .foregroundColor(Color.myFadePrimary)
                .background(Color.white)
                .cornerRadius(size * 0.5 )
        }
    }
}

struct NextButton_Previews: PreviewProvider {
    static var previews: some View {
        NextButton(size: 50) {
            print("skip")
        }
    }
}

