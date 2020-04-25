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
    var isFriend: Bool = false
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
    
    func bioText () -> AnyView? {
        if let s = profile.bio {
            return AnyView(Text(s)
                .font(.body)
                .lineLimit(nil)
                .foregroundColor(Color.myText)
                .padding(.horizontal, ThemeDimensions.mdSpace)
            )
        } else {
            return nil
        }
    }
    
    func bioPrompts () -> AnyView? {
        if let prompts = profile.prompts?.filter({ prompt in prompt.show}) {
            return AnyView(VStack(alignment: .leading) {
                ForEach(prompts, id: \.title) { q in
                    VStack(alignment: .leading) {
                        Text(q.title).font(.subheadline).foregroundColor(Color.myText)
                        Text(q.answer!).font(.body).foregroundColor(Color.myText)
                    }.padding(.vertical, ThemeDimensions.smSpace)
                    } //end of ForeEach
                }) // end of VStack
            }
        else { return nil }
    }
    
    func myLabels (list: [String], label: String) -> AnyView? {
        if list.count > 0 {
        
            let tagsView = TagList(labels: list, bgColor: Color.myFadePrimary, textColor: Color.white)
                .padding(.trailing, ThemeDimensions.mdSpace)
                .padding(.leading, ThemeDimensions.smSpace)
                .frame(minHeight: (CGFloat(list.count/3)+1) * 25.0 )
                // This is a hacky rough estimate, but until we can do better, we'll keep this for now
            
            return AnyView(VStack(alignment: .leading, spacing: ThemeDimensions.smSpace){
                Text(label)
                .font(.subheadline)
                .foregroundColor(Color.myText)
                .padding(.horizontal, ThemeDimensions.mdSpace)
                .padding(.vertical, 0)
                tagsView
            })
           // return AnyView(tagsView)
        } else {return nil}
    }
    
    
    func returnToList(likes: Bool){
        DataTango.likeProfile(self.profile.uuid)
        self.goBack()
        self.presentation.wrappedValue.dismiss()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: ThemeDimensions.lgSpace) {
                   picture().resizable().frame(width: nil, height: 400, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: ThemeDimensions.smSpace) {
                        Text(profile.name).font(.title).foregroundColor(Color.myTitle)
                        
                        basicInfo()?.foregroundColor(Color.myText).font(.body)
                        
                        HStack(alignment: .top, spacing: ThemeDimensions.lgSpace) {
                            KinksCountView(count: profile.kinksMatched).fixedSize(horizontal: false, vertical: true)
                            
                            if profile.vouches > 0 {
                                VouchCountView(count: profile.vouches).fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }.padding(.horizontal, ThemeDimensions.mdSpace)
                    
                  bioText()
                    

                    myLabels(list: profile.genders, label: "My gender(s) are")
                    myLabels(list: profile.roles, label: "Role(s) I play are")
                    
                    if isFriend {
                        myLabels(list: self.profile.kinks.map { k in
                            return k.label
                        }, label: "I'm into")
                    }
                    
                    bioPrompts()?.padding(.horizontal, ThemeDimensions.mdSpace).padding(.top, ThemeDimensions.lgSpace)
                    
                    // To give additional space between content and buttons
                    Rectangle().frame(minWidth: 10, idealWidth: nil, maxWidth: nil, minHeight: 50, idealHeight: nil, maxHeight: nil, alignment: .center)
                        .foregroundColor(Color.white)
                    
                } // end of content stack
            } //end of scroll view
            if !isFriend {
                HStack(alignment: .center, spacing: 24) {
                    NextButton(size: 32){
                        
                        self.returnToList(likes: false)
                    }
                    HeartButton(size: 48) {
                        DataTango.likeProfile(self.profile.uuid)
                        self.returnToList(likes: true)
                    }
                }.padding()
            }
        }.background(Color.white)
        .onAppear {
            if self.profile.age == 0 {
                DataTango.readProfile(self.profile.uuid) { profile in
                    self.profile = profile
                }
            }
        }
    } // end of view
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profile: mockFullProfile() , isFriend: true, goBack: {
            print("return")
        }).environmentObject(mockDM())
    }
}

