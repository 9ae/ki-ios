//
//  TagList.swift
//  Discovery
//
//  Created by Alice Q Wong on 2/29/20.
//  Copyright © 2020 Alice Q Wong. All rights reserved.
//

import SwiftUI

struct TagList: View {
    
    var labels : [String]
    var bgColor: Color
    var textColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }
    
    func item(for text: String) -> some View {
        Text(text)
            .padding(5)
            .font(.caption)
            .background(self.bgColor)
            .foregroundColor(self.textColor)
            .cornerRadius(10)
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.labels, id: \.self) { platform in
                self.item(for: platform)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if platform == self.labels.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if platform == self.labels.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
    }
}

struct TagList_Previews: PreviewProvider {
    static var previews: some View {
        TagList(labels: ["agender","non-binary","domme", "exhibitionist", "masochist","curious about", "dabbled with", "learning", "practicing", "skilled in", "master of"], bgColor: Color.pink, textColor: Color.white)
    }
}

