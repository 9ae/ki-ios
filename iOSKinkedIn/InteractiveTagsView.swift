//
//  InteractiveTagsView.swift
//  iOSKinkedIn
//
//  Created by Alice on 3/3/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import SwiftUI

struct Tag {
    var label : String
    var isActive : Bool
}

struct InteractiveTagsView: View {
   @State var tags : [Tag]
   var updateFn: (String, Bool) -> Void
   
   var body: some View {
       GeometryReader { geometry in
           self.generateContent(in: geometry)
       }
   }
   
   func item(for tag: Tag) -> some View {
       Button(action: {
           if let index = self.tags.firstIndex(where: { t in t.label == tag.label })
           {
               let newTag = Tag(label: tag.label, isActive: !tag.isActive)
               self.updateFn(newTag.label, newTag.isActive)
               self.tags.remove(at: index)
               self.tags.insert(newTag, at: index)
           }
       }){
           Text(tag.label)
               .foregroundColor(Color.white)
               .font(.body)
               .padding(5)
       }
       .background(tag.isActive ? Color.myPrimary : Color.myFadePrimary)
       
       .cornerRadius(10)
   }
   
   private func generateContent(in g: GeometryProxy) -> some View {
       var width = CGFloat.zero
       var height = CGFloat.zero

       return ZStack(alignment: .topLeading) {
           ForEach(self.tags, id: \.label) { tag in
               self.item(for: tag)
                   .padding([.horizontal, .vertical], 4)
                   .alignmentGuide(.leading, computeValue: { d in
                       if (abs(width - d.width) > g.size.width)
                       {
                           width = 0
                           height -= d.height
                       }
                       let result = width
                       if tag.label == self.tags.last?.label {
                           width = 0 //last item
                       } else {
                           width -= d.width
                       }
                       return result
                   })
                   .alignmentGuide(.top, computeValue: {d in
                       let result = height
                       if tag.label == self.tags.last?.label {
                           height = 0 // last item
                       }
                       return result
                   })
           }
       }
   }
}

struct InteractiveTagsView_Previews: PreviewProvider {
    static var previews: some View {
        InteractiveTagsView(tags: [
            Tag(label: "agender", isActive: true),
            Tag(label: "bunny", isActive: true),
            Tag(label: "doctor", isActive: false),
            Tag(label: "friend", isActive: true),
            Tag(label: "rainbow dash", isActive: true),
            Tag(label: "dinosaur", isActive: false),
            Tag(label: "care bear", isActive: true),
            Tag(label: "hijra", isActive: false),
            Tag(label: "mage", isActive: true),
        ], updateFn: { (label, active) in print("\(label) is now \(active)") } )
    }
}
