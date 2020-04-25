//
//  VouchView.swift
//  iOSKinkedIn
//
//  Created by Alice on 3/7/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import SwiftUI

struct VouchView: View {
    
    var profile : Profile
    
    @State var isVouchReady = false
    
    @State var qHonest : Bool? = nil
    @State var qBoundaries : Bool? = nil
    @State var qCommunicate : Bool? = nil
    
    @Environment (\.presentationMode) var presentation
    
    func btnColor(_ answer : Bool?, isYes: Bool) -> Color {
        if answer == isYes {
          return Color.white
        } else if answer == !isYes {
            return Color.myFadePrimary
        } else {
            return Color.myPrimary
        }
    }
    
    func bgColor(_ answer : Bool?, isYes: Bool) -> Color {
        if (answer == isYes){
            return Color.myPrimary
        } else {
            return Color.clear
        }
    }
    
    var body: some View {
        ScrollView{
            if isVouchReady {
            VStack(alignment: .leading) {
                Text("Was \(profile.name) honest in the information (photos and text) they provided in their profile?")
                HStack(spacing: 40) {
                    Spacer()
                    Button(action: { self.qHonest = false}){Text("No").padding(8)}
                        .foregroundColor(btnColor(qHonest, isYes: false))
                        .background(bgColor(qHonest, isYes: false))
                        .cornerRadius(16)
                    Button(action: { self.qHonest = true }) { Text("Yes").padding(8)}
                        .foregroundColor(btnColor(qHonest, isYes: true))
                        .background(bgColor(qHonest, isYes: true))
                        .cornerRadius(16)
                }.padding()
                
                Spacer()
                
                Text("Was \(profile.name) respectful of your boundaries?")
                HStack(spacing: 40) {
                    Spacer()
                    Button(action: { self.qBoundaries = false}){Text("No").padding(8)}
                        .foregroundColor(btnColor(qBoundaries, isYes: false))
                        .background(bgColor(qBoundaries, isYes: false))
                        .cornerRadius(16)
                    Button(action: { self.qBoundaries = true }) { Text("Yes").padding(8)}
                        .foregroundColor(btnColor(qBoundaries, isYes: true))
                        .background(bgColor(qBoundaries, isYes: true))
                        .cornerRadius(16)
                }.padding()
                
                Spacer()
                
                Text("Was \(profile.name) an good communicator?")
                HStack(spacing: 40) {
                    Spacer()
                    Button(action: { self.qCommunicate = false}){Text("No").padding(8)}
                        .foregroundColor(btnColor(qCommunicate, isYes: false))
                        .background(bgColor(qCommunicate, isYes: false))
                        .cornerRadius(16)
                    Button(action: { self.qCommunicate = true }) { Text("Yes").padding(8)}
                        .foregroundColor(btnColor(qCommunicate, isYes: true))
                        .background(bgColor(qCommunicate, isYes: true))
                        .cornerRadius(16)
                }.padding()
                
                Spacer()
                
                Text("By submitting you are saying that the feedback you provide is based on your interactions with \(profile.name).").font(.footnote)
            }.padding() }
            else {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Vouching is like recommending someone to a friend.\n\nWe suggest only vouching for community members you have played with. By vouching for someone, you are sharing that in your experience with them, they respected your boundaries and were honest in their communication.").font(.body)
                    
                    Button(action:{
                        self.isVouchReady = true
                    }){Text("Yes! I feel qualified to vouch for \(profile.name)").foregroundColor(Color.myAction).font(.headline)}
                    
                    Spacer()
                    Text("Your feedback will not negatively affect \(profile.name)'s reputation.").font(.body)
                    
                    Text("If you need to talk to someone about your experience with \(profile.name), you can do so by selecting \"Reach Out to Care Team\" in the options menu in your message screen with them.")

                    Spacer()
                    
                }.padding() // end of vstack
            }
        }
        .navigationBarItems(trailing: Button(action:{
            guard let honest = self.qHonest else {return}
            guard let communicate = self.qCommunicate else {return}
            guard let respect = self.qBoundaries else {return}
            
            let answers = [
                "communicate": communicate,
                "honest": honest,
                "respect": respect
            ]
            
            DataTango.vouch(self.profile.uuid, answers: answers)
            self.presentation.wrappedValue.dismiss()
        }){ Text("Submit").foregroundColor(Color.white) }.disabled(!self.isVouchReady) )
    } // END OF body
}

struct VouchView_Previews: PreviewProvider {
    static var previews: some View {
        VouchView(profile: mockProfile)
    }
}
