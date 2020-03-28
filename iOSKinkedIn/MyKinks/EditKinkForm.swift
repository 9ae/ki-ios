//
//  EditKinkForm.swift
//  iOSKinkedIn
//
//  Created by Alice on 3/28/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import SwiftUI

struct EditKinkForm: View {
    @State var kinks : [Kink]
    let formSentence: String
    @Binding var searchLabels : String
    let kink2tagFn : (Kink) -> Tag
    let markFn : (Kink, Bool) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(formSentence)
            TextField("what you're into?", text: $searchLabels)
            InteractiveTagsView(tags: kinks.map(self.kink2tagFn))
                { (label, selected) in
                    if let kink = self.kinks.first(where: { k  in
                        k.label == label
                    }) { self.markFn(kink, selected) }
                }
        }
    }
}

struct EditKinkForm_Previews: PreviewProvider {
    static var previews: some View {
        EditKinkForm(kinks: mockKinksService,
        formSentence: "I want to receive",
        searchLabels: .constant(""),
        kink2tagFn: {k in Tag(label: k.label, isActive: k.way == .get)},
        markFn: {(kink, active) in
            if active {
                if kink.way == .give {
                    kink.way = .both
                } else {
                    kink.way == .get
                }
            }
            else {
                if kink.way == .both {
                    kink.way = .get
                } else {
                    kink.way = .none
                }
            }
            }
        )
    }
}
