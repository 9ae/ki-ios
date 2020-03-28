//
//  AllForms.swift
//  iOSKinkedIn
//
//  Created by Alice on 3/28/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import SwiftUI

struct AllForms: View {
    var kinks: [Kink]
    var body: some View {
        NavigationView{
        ScrollView(.vertical, showsIndicators: true) {
            VStack{
                /*
                FormRow(label: "I am turned on by", kinks: kinks.filter{k in
                    if (k.form == .wearable){
                       return k.way == .get
                    } else if (k.form == .accessory || k.form == .aphrodisiac || k.form == .other){
                        return k.way != .none
                    } else {
                        return false;
                    }
                }, destination: )
                
                FormRow(label: "I want to receive", kinks: kinks.filter{k in k.form == .service && k.way == .get }, destination:  )
                */
                    
                FormRow(label: "I can provide you with", kinks: kinks.filter{k in k.form == .service && k.way == .give }, destination:                 EditKinkForm(kinks: mockKinksService, formSentence: "I can provide you with", searchLabels: .constant(""), kink2tagFn: {kink in Tag(label: kink.label, isActive: kink.way == .give || kink.way == .both) }, markFn: { (kink, active) in
                    if active {
                        if kink.way == .get {kink.way = .both} else {kink.way = .give}
                    } else {
                        if kink.way == .both {kink.way = .get} else {kink.way = .give}
                    }
                }))
                
                /*
                FormRow(label: "I like to wear", kinks: kinks.filter{k in
                    k.form == .wearable && (k.way == .give || k.way == .both)
                }, destination:)
                
                FormRow(label: "I fantasize about", kinks: kinks.filter{k in
                    k.form == .act && k.way != .none
                }, destination:)
                */
            } // vstack
        } // scroll view
        } // navigation view ~ remove later we'll it's parent is in a navigation view already
    } // body
}

struct AllForms_Previews: PreviewProvider {
    static var previews: some View {
        AllForms(kinks: mockKinksActs + mockKinksService + mockKinksOmake )
    }
}
