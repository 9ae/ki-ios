//
//  PreferencesView.swift
//  Discovery
//
//  Created by Alice Q Wong on 2/29/20.
//  Copyright © 2020 Alice Q Wong. All rights reserved.
//

import SwiftUI

struct PreferencesView: View {

    @EnvironmentObject var dm : DM
    
    func makeTags(all: [String], choosen: [String]) -> [Tag] {
        return all.map { label in
            let isActive = choosen.contains(label)
            return Tag(label: label, isActive: isActive)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline, spacing: 16) {
                Text("Min Age")
                Spacer()
                TextField("18", text: $dm.preferences.minAge)
                    .keyboardType(/*@START_MENU_TOKEN@*/.numberPad/*@END_MENU_TOKEN@*/)
                    .frame(width: 40)
            }
            HStack(alignment: .firstTextBaseline) {
                Text("Max Age")
                Spacer()
                TextField("100", text: $dm.preferences.maxAge)
                    .keyboardType(/*@START_MENU_TOKEN@*/.numberPad/*@END_MENU_TOKEN@*/)
                    .frame(width: 40)
            }
            VStack(alignment: .leading) {
                Text("Looking for people who identify as")
                
                InteractiveTagsView(tags: makeTags(all: dm.genders, choosen: dm.preferences.genders)) { (label, active) in
                    if active {
                        self.dm.preferences.genders.append(label)
                    } else {
                        self.dm.preferences.genders = self.dm.preferences.genders.filter({ gender in
                            gender != label
                        })
                    }
                }
            }
            
            VStack(alignment: .leading) {
                Text("Looking for people who are")
               InteractiveTagsView(tags: makeTags(all: dm.roles, choosen: dm.preferences.roles), updateFn: { (label, active) in
                if (active) {
                    self.dm.preferences.roles.append(label)
                } else {
                    self.dm.preferences.roles = self.dm.preferences.roles.filter({role in role != label})
                }
               })
            }
        }.padding()
        .navigationBarTitle("Preferences")
    } // end of body
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView().environmentObject(mockDM())
    }
}

