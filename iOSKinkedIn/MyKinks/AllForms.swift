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
    @State var myGiveService : [Kink] = []
    @State var myGetService : [Kink] = []
    @State var myActs : [Kink] = []
    @State var myWears : [Kink] = []
    @State var wearableKinks : [Kink] = []
    
    func kinks () -> [Kink] {
        if let pro = dm.myProfile() {
            return pro.kinks
        } else {
            return []
        }
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
    
    static func filterGiveService(_ k : Kink) -> Bool {
        if (k.form == .service) {
            return k.way == .give || k.way == .both
        } else {return false}
    }
    
    static func filterGetService(_ k: Kink) -> Bool {
        if (k.form == .service) {
            return k.way == .get || k.way == .both
        } else {return false}
    }
    
    static func filterWears(_ k: Kink) -> Bool {
        if (k.form == .wearable) {
            return k.way == .give || k.way == .both
        } else {return false}
    }
    
    static func filterActs(_ k: Kink) -> Bool {
        if (k.form == .act) {
            return k.way == .both
        } else {return false}
    }

    func markGiveService (_ kink: Kink, _ active: Bool) -> Void {
        if active {
            kink.addGive()
        } else {
            kink.rmGive()
        }
        self.dm.updateMyProfileWithKink(kink)
    }
    
    func markGetService(_ kink: Kink, _ active: Bool) -> Void {
        if active {
            kink.addGet()
        } else {
            kink.rmGet()
        }
        self.dm.updateMyProfileWithKink(kink)
    }
    
    func markOmake (_ kink: Kink, _ active: Bool) -> Void {
        if active {
            switch kink.form {
            case .wearable:
                kink.addGet()
                break;
            default:
                kink.way = .both
            }
        } else {
            switch kink.form {
                case .wearable:
                    kink.rmGet()
                    break
                default:
                    kink.way = .none
                    break
            }
        }
        self.dm.updateMyProfileWithKink(kink)
    }
    
    func markWear (_ kink: Kink, _ active: Bool) -> Void {
        if active {
            kink.addGive()
        } else {
            kink.rmGive()
        }
        self.dm.updateMyProfileWithKink(kink)
    }
    
    func markAct (_ kink: Kink, _ active: Bool) -> Void {
        if active {
            kink.way = .both
        } else {
            kink.way = .none
        }
        self.dm.updateMyProfileWithKink(kink)
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
                
                formRow(label: "I am turned on by",
                        kinks: dm.kinksOmake,
                        myKinks: myOmake,
                        myFilter: AllForms.filterOmake,
                        markFn: markOmake)
                
                formRow(label: "I want to receive", kinks: dm.kinksService, myKinks: myGetService,
                        myFilter: AllForms.filterGetService, markFn: markGetService)
                
                formRow(label: "I can provide you with", kinks: dm.kinksService, myKinks: myGiveService,
                        myFilter: AllForms.filterGiveService, markFn: markGiveService)
                
                formRow(label: "I like to wear", kinks: wearableKinks, myKinks: myWears,
                        myFilter: AllForms.filterWears, markFn: markWear)
                
                formRow(label: "I fantasize about", kinks: dm.kinksAct, myKinks: myActs,
                        myFilter: AllForms.filterActs, markFn: markAct)

            } // vstack
        } // scroll view
            .onAppear {
                self.myOmake = self.dm.myProfile()?.kinks.filter(AllForms.filterOmake) ?? []
                self.myGiveService = self.dm.myProfile()?.kinks.filter(AllForms.filterGiveService) ?? []
                self.myGetService = self.dm.myProfile()?.kinks.filter(AllForms.filterGetService) ?? []
                self.myWears = self.dm.myProfile()?.kinks.filter(AllForms.filterWears) ?? []
                self.myActs = self.dm.myProfile()?.kinks.filter(AllForms.filterActs) ?? []
                
                self.wearableKinks = self.dm.kinksOmake.filter({ k in k.form == .wearable })
            }
        } // navigation view ~ remove later we'll it's parent is in a navigation view already
    } // body

}

struct AllForms_Previews: PreviewProvider {
    static var previews: some View {
        AllForms().environmentObject(mockDM())
    }
}
