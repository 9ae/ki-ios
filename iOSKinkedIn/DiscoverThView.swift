//
//  DiscoverThView.swift
//  iOSKinkedIn
//
//  Created by Alice on 3/7/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import SwiftUI

struct DiscoverThView: View {

   var profile : Profile
   
   func picture() -> Image {
       if let pic_url = profile.picture {
           let url = URL(string: pic_url)
           do {
               let imgData = try Data(contentsOf: url!)
               let img = UIImage(data: imgData)
              return Image(uiImage: img!)
           } catch {
             return Image(systemName: "icloud")
           }
       } else {
         return  Image(systemName: "icloud")}
   }
   
   func vouchCount(_ count: Int) -> VouchCountView? {
       if count > 0 {
           return VouchCountView(count: count)
       } else {
           return nil
       }
   }
   
   var body: some View {
       GeometryReader { geometry in
       ZStack(alignment: .bottomTrailing) {
           self.picture().resizable()
           HStack(alignment: .top, spacing: 16) {
               Text(self.profile.name)
                   .padding(.horizontal, 16)
                   .font(.headline)
                   .foregroundColor(Color.myBG)
               
               KinksCountView(count: self.profile.kinksMatched)
               
               self.vouchCount(self.profile.vouches)
           }
           .frame(width: geometry.size.width , height: 64, alignment: .leading)
           .fixedSize(horizontal: false, vertical: true)
           .background(Color(hue: 0, saturation: 0, brightness: 0.1, opacity: 0.8))
          /* VStack(alignment: .center, spacing: 24) {
               HeartButton(size: 36){print("liked")}
                   .shadow(color: Color.gray, radius: 2, x: -1, y: 1)
               NextButton(size: 25){print("skip")}
           }
           .padding(.trailing, 8)
           .padding(.bottom, 8) */
       }
       .background(Color.white)
       }
   } // END OF view
}

struct DiscoverThView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverThView(profile: mockProfile).previewLayout(.fixed(width: 375, height: 230))
    }
}
