//
//  AllForms.swift
//  iOSKinkedIn
//
//  Created by Alice on 3/28/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import SwiftUI

struct AllForms: View {
    
    @EnvironmentObject var dm : Dungeon
    @State var myOmake : [Kink] = []
    
    func kinks () -> [Kink] {
       return self.dm.myProfle?.kinks ?? []
    }
    
    static func isKinkIn(_ kinks : [Kink], code: String) -> Bool {
        return kinks.contains { k in
            k.code == code
        }
    }
    
    static func join (all : [Kink], mine: [Kink]) -> [Kink] {
        let others = all.filter{k in !isKinkIn( mine, code: k.code)}
        return others + mine
    }
    
    static func filterOmake (_ k : Kink) -> Bool {
        if (k.form == .wearable){
            return (k.way == .get || k.way == .both)
        } else if (k.form == .accessory || k.form == .aphrodisiac || k.form == .other){
            return k.way != .none
        } else {
          return false
        }
    }

    func markGiveService (_ kink: Kink, _ active: Bool) -> Void {
        if active {
            if kink.way == .get {kink.way = .both} else {kink.way = .give}
        } else {
            if kink.way == .both {kink.way = .get} else {kink.way = .give}
        }
        self.dm.updateMyProfileWithKink(kink)
    }
    
    func markOmake (_ kink: Kink, _ active: Bool) -> Void {
        // TODO more detail later
        if active {
            kink.way = .both
        } else {
            kink.way = .none
        }
        self.dm.updateMyProfileWithKink(kink)
        print(dm.myProfle?.kinks.map{k in k.label}.joined(separator: ","))
    }
    
    func formRow(label: String, kinks: [Kink], myKinks:[Kink], myFilter: @escaping (Kink) -> Bool, markFn: @escaping (Kink, Bool) -> Void) -> AnyView {

        let destination = EditKinkForm(kinks: AllForms.join(all: kinks, mine: myKinks),
        formSentence: label,
        searchLabels: .constant(""),
        kink2tagFn: {k in Tag(label: k.label, isActive: myFilter(k))},
        markFn: markFn)
        
        let kinksPreview = myKinks.count > 0 ? myKinks.map{ k in k.label }.joined(separator: ", ") : "None yet. What are you into?"
        
        let view = VStack(alignment: .leading)  {
            HStack {
                Text(label).font(.body).foregroundColor(Color.myText)
                Spacer()
                NavigationLink(destination: destination) {
                    Image(systemName: "pencil.circle").foregroundColor(Color.myAction)
               }
            }
            Text(kinksPreview).font(.caption).lineLimit(1).foregroundColor(Color.myPrimary)
        }.padding(.horizontal, 16)
        
        return AnyView(view)
    }
    
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
                
                formRow(label: "I am turned on by",
                        kinks: dm.kinksOmake,
                        myKinks: myOmake,
                        myFilter: AllForms.filterOmake,
                        markFn: markOmake)
                /*
                formRow(label: "I can provide you with",
                        kinks: dm.kinksService,
                        myKinks: kinks().filter{k in k.form == .service && k.way == .give },
                        kink2tagFn: {kink in Tag(label: kink.label, isActive: kink.way == .give || kink.way == .both) },
                        markFn: markGiveService)
                */
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
            .onAppear {
                self.myOmake = self.dm.myProfle?.kinks.filter(AllForms.filterOmake) ?? []
            }
        } // navigation view ~ remove later we'll it's parent is in a navigation view already
    } // body

}

struct AllForms_Previews: PreviewProvider {
    static var previews: some View {
        AllForms().environmentObject(mockDM())
    }
}
