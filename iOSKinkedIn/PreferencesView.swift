//
//  PreferencesView.swift
//  Discovery
//
//  Created by Alice Q Wong on 2/29/20.
//  Copyright © 2020 Alice Q Wong. All rights reserved.
//

import SwiftUI

struct PreferencesView: View {

    @EnvironmentObject var preferences : DiscoveryPreferences
    
    @State var genders : [String] = []
    @State var roles : [String] = []
    
    func makeTags(all: [String], choosen: [String]) -> [Tag] {
        return all.map { label in
            let isActive = choosen.contains(label)
            return Tag(label: label, isActive: isActive)
        }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .firstTextBaseline, spacing: 16) {
                    Text("Min Age")
                    Spacer()
                    TextField("18", text: $preferences.minAge)
                        .keyboardType(/*@START_MENU_TOKEN@*/.numberPad/*@END_MENU_TOKEN@*/)
                        .frame(width: 40)
                }
                HStack(alignment: .firstTextBaseline) {
                    Text("Max Age")
                    Spacer()
                    TextField("100", text: $preferences.maxAge)
                        .keyboardType(/*@START_MENU_TOKEN@*/.numberPad/*@END_MENU_TOKEN@*/)
                        .frame(width: 40)
                }

                Text("Looking for people who identify as")
                if (genders.count == 0){
                    Text("loading")
                } else {
                InteractiveTagsView(tags: makeTags(all: genders, choosen: preferences.genders)) { (label, active) in
                    self.preferences.setGender(label: label, add: active)
                }.frame(minHeight: 300) // end of tags view
              }
                
                Text("Looking for people who are").padding(.top, 20)
                if (roles.count == 0){
                    Text("loading")
                } else {
                    InteractiveTagsView(tags: makeTags(all: roles, choosen: preferences.roles)){ (label, active) in
                        self.preferences.setRole(label: label, add: active)
                    }.frame(minHeight: 300)
                } // end of else
                    
            }.padding()
        }
        .navigationBarTitle("Preferences")
        .onAppear {
            if (self.genders.count == 0){
                DataTango.genders { genders in
                    self.genders = genders
                }
            }
            
            if(self.roles.count == 0){
                DataTango.roles { roles in
                    self.roles = roles
                }
            }
        }
        .onDisappear {
            //TODO update API
        }
    } // end of body
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView().environmentObject(mockDM().preferences)
    }
}

