//
//  EditIDsView.swift
//  iOSKinkedIn
//
//  Created by Alice on 4/11/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import SwiftUI

struct EditIDsView: View {
    
    var kind : String
    var all: [String]
    @State var mine : [String]
    
     @Environment (\.presentationMode) var presentation
    
    func makeTags() -> [Tag] {
        return all.map { label in
            let isActive = mine.contains(label)
            return Tag(label: label, isActive: isActive)
        }
    }
    
    func save(){
        print("update")
        if self.kind == "Genders" {
            print("genders")
            KinkedInAPI.updateProfile(["genders": self.mine])
        }
        if self.kind == "Roles" {
            print("roles")
            KinkedInAPI.updateProfile(["roles": self.mine])
        }
        self.presentation.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            Text("\(kind) I identify with are")
            InteractiveTagsView(tags: makeTags() ) { (label, active) in
                if(active) {
                    self.mine.append(label)
                } else {
                    self.mine.removeAll{ l in l == label }
                }
            }
        }.padding()
        .navigationBarItems(trailing:
            Button(action: self.save, label: {
                Text("Save")
            })
        )
    } //end of body
}

struct EditIDsView_Previews: PreviewProvider {
    static var previews: some View {
        EditIDsView(kind: "Genders", all: ["agender", "andrygynous", "bigender", "cisman", "ciswoman", "gender non-conforming", "genderfluid", "hijra", "intersex", "man", "non-binary", "other", "pangender", "trans man", "trans woman", "transfeminine", "transgender", "transmasculine", "transsexual", "two spirit", "woman"], mine: ["agender", "two spirit"])
    }
}
