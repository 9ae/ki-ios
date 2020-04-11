//
//  FormRow.swift
//  iOSKinkedIn
//
//  Created by Alice on 3/28/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import SwiftUI

struct FormRow: View {
    let label: String
    @EnvironmentObject var dm : Dungeon
    let filter : (Kink) -> Bool
    
    let destination: EditKinkForm
    
    func kinksPreview () -> String {
        let kinks = dm.myProfle?.kinks.filter(self.filter) ?? []
        if kinks.count > 0 {
           return kinks.map{ k in k.label }.joined(separator: ", ")
        } else {
            return "None yet. What are you into?"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading)  {
            HStack {
                Text(label).font(.body).foregroundColor(Color.myText)
                Spacer()
                NavigationLink(destination: destination) {
                    Image(systemName: "pencil.circle").foregroundColor(Color.myAction)
               }
            }
            Text(self.kinksPreview()).font(.caption).lineLimit(1).foregroundColor(Color.myPrimary)
        }.padding(.horizontal, 16)
    }
}

struct FormRow_Previews: PreviewProvider {
    static var previews: some View {
        FormRow(
            label:"I want to receive",
        //    kinks: .constant(mockKinksService),
            filter: {k in k.form == .service && k.way == .get },
            destination: EditKinkForm(kinks: [], formSentence: "I want to receive", searchLabels: .constant(""), kink2tagFn: {k in Tag(label: k.label, isActive: true)}, markFn: { (kink, active) in
                print("marked")
            })
            ).previewLayout(.fixed(width: 375, height: 60))
        .environmentObject(mockDM())
    }
}
