//
//  ProfileView.swift
//  Discovery
//
//  Created by Alice Q Wong on 2/22/20.
//  Copyright © 2020 Alice Q Wong. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment (\.presentationMode) var presentation
    @EnvironmentObject var dm : Dungeon
    
    @State var profile : Profile
    var goBack : () -> Void
    
    func picture() -> Image {
        
        if let pic_url = profile.picture {
            let url = URL(string:pic_url)
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
    
    func basicInfo () -> Text? {
        if let city = profile.city {
         return Text("\(profile.age) years old, living in \(city)")
        } else {
            return nil
        }
    }
    
    func bioText () -> Text? {
        if let s = profile.bio {
            return Text(s)
        } else {
            return nil
        }
    }
    
    func bioPrompts () -> AnyView? {
        if let prompts = profile.prompts?.filter({ prompt in prompt.show}) {
            return AnyView(VStack(alignment: .leading) {
                ForEach(prompts, id: \.title) { q in
                    VStack(alignment: .leading) {
                        Text(q.title).font(.caption).foregroundColor(Color.myText)
                        Text(q.answer!).font(.body).foregroundColor(Color.myText)
                    }.padding(.vertical, 8)
                    } //end of ForeEach
                }) // end of VStack
            }
        else { return nil }
    }
    
    func myKinks () -> AnyView? {
        if profile.kinks.count > 0 {
            let kinks = profile.kinks.map { k in
                return k.label
            }
            return AnyView(VStack(alignment: .leading, spacing: 4){
                Text("I'm into...").font(.subheadline).foregroundColor(Color.myText)
                TagList(labels: kinks, bgColor: Color.myPrimary, textColor: Color.white).padding(.leading, -8)
            })
        } else { return nil }
    }
    
    func returnToList(likes: Bool){
        dm.markProfile(self.profile, likes: likes)
        self.goBack()
        self.presentation.wrappedValue.dismiss()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 16) {
                    picture().resizable().frame(width: nil, height: 400, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(profile.name).font(.title).foregroundColor(Color.myTitle)
                        
                        basicInfo()?.foregroundColor(Color.myText).font(.body)
                        
                        HStack(alignment: .top, spacing: 16) {
                            KinksCountView(count: profile.kinksMatched).fixedSize(horizontal: false, vertical: true)
                            
                            if profile.vouches > 0 {
                                VouchCountView(count: profile.vouches).fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }.padding(.horizontal, 16)
                    
                    bioText()?.padding(16).font(.body).lineLimit(nil).foregroundColor(Color.myText)
                    
                    VStack(alignment: .leading, spacing: 4){
                        Text("My gender(s) are:").font(.subheadline).foregroundColor(Color.myText)
                        TagList(labels: profile.genders, bgColor: Color.myFadePrimary, textColor: Color.white).padding(.leading, -8)
                        Spacer()
                        Text("Role(s) I play are:").font(.subheadline).foregroundColor(Color.myText).padding(.top, 16)
                        TagList(labels: profile.roles, bgColor: Color.myFadePrimary, textColor: Color.white).padding(.leading, -8)
                    }.padding(.horizontal, 16)
                    
                    myKinks().padding(.horizontal, 16).padding(.top, 24)
                    
                    bioPrompts()?.padding(.horizontal, 16).padding(.top, 24)
                    
                    // To give additional space between content and buttons
                    Rectangle().frame(minWidth: 10, idealWidth: nil, maxWidth: nil, minHeight: 50, idealHeight: nil, maxHeight: nil, alignment: .center)
                        .foregroundColor(Color.white)
                    
                } // end of content stack
            } //end of scroll view
            HStack(alignment: .center, spacing: 24) {
                NextButton(size: 32){
                    print("skip")
                    self.returnToList(likes: false)
                }
                HeartButton(size: 48) {
                    print("like")
                    self.returnToList(likes: true)
                }
            }.padding()
        }.background(Color.myBG)
        .onAppear {
            if self.profile.age == 0 {
                KinkedInAPI.readProfile(self.profile.uuid) { profile in
                    self.profile = profile
                }
            }
        }
    } // end of view
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profile: mockFullProfile() , goBack: {
            print("return")
        }).environmentObject(mockDM())
    }
}

