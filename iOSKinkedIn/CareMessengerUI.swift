//
//  CareMessengerUI.swift
//  iOSKinkedIn
//
//  Created by Alice on 2/2/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import SwiftUI


struct CareMessengerUI: View {
    
    @State var q : CareQuestion
    @Binding var msg : String
    @State var log : [String]
    
    func next(_ cq: CareQuestion) -> Void {
        if let next = cq.followup.first {
            self.q = next
        } else {
            print("no follow up to option")
        }
    }

    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: true) {
                List(log, id: \.self ){ txt in
                    Text(txt).foregroundColor(Color.black)
                }
            }
            //Input block
            if (q.type == .question){
                HStack {
                   TextField("compose msg", text: $msg)
                    Button(action: {
                        print("sending: \(self.msg)")
                        self.log.append(self.q.message)
                        self.next(self.q)
                    }) {Text("Send")}
                }
                .padding(10)
            } else if (q.type == .choice){
                List(q.followup, id: \.id){cq in
                    Button(action: {
                        self.log.append(cq.message)
                        self.next(cq)
                    }){
                        Text(cq.message)
                            .foregroundColor(Color.white)
                            .padding(8)
                    }
                    .background(RoundedRectangle(cornerRadius: 12, style: .circular))
                    .foregroundColor(Color.pink)
//                    .alignmentGuide(HorizontalAlignment.trailing) { d in d[.trailing] }

                }
                .onAppear {
                    UITableView.appearance().separatorStyle = .none
                }
                .onDisappear() {
                    UITableView.appearance().separatorStyle = .singleLine
                }
            } else {
                Spacer()
            }
        }
    }
}

struct CareMessengerUI_Previews: PreviewProvider {
    static var previews: some View {
        CareMessengerUI(q: mockAftercareFlow, msg: .constant(""), log: ["Hello"])
    }
}
