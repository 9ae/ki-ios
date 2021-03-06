//
//  DiscoveryView.swift
//  iOSKinkedIn
//
//  Created by Alice on 3/1/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import SwiftUI

struct DiscoveryView: View {
    @EnvironmentObject var dm : Dungeon
    @State var showDailyMatches = false
    @State var isProfilesFetched = false
    @State var isDailyMatchesFetched = false
    
    init(){
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {

            List(dm.discoverProfiles, id: \.uuid){ pro in
                NavigationLink(destination: ProfileView(profile: pro, goBack: {self.showDailyMatches = self.dm.dailyMatches.count > 0}) ){
                    DiscoverThView(profile: pro)
                        .frame(width: nil, height: 230, alignment: .top)
                        .cornerRadius(16)
                        .shadow(color: Color.gray, radius: 7, x: 1, y: 2)
                }
            } // end of list

            DailyMatchesView(hideAction: {
                self.showDailyMatches = false
            }).offset(x: 0, y: showDailyMatches ? 0 : -300).animation(.easeIn)
                .clipped()
                .shadow(color: Color.black, radius: 8, x: 0, y: 5)
            } // end of zStack
            .navigationBarItems(trailing:
                NavigationLink(destination: PreferencesView().environmentObject(dm.preferences), label: {
                    Image(systemName: "slider.horizontal.3").foregroundColor(Color("primaryColor"))
                })
                    .padding(.trailing, 16)
            )
           .navigationBarHidden(showDailyMatches)
        } // end of nav view
        .background(Color.white)
        .onAppear {
            self.showDailyMatches = self.dm.dailyMatches.count > 0
            
            if self.dm.discoverProfiles.count == 0 && !self.isProfilesFetched {
                DataTango.discoverProfiles { profiles in
                    self.dm.discoverProfiles = profiles
                    self.isProfilesFetched = true
                }
            }
            
            if self.dm.dailyMatches.count == 0 && !self.isDailyMatchesFetched {
                DataTango.dailyMatches { profiles in
                    self.dm.dailyMatches = profiles
                    self.showDailyMatches = profiles.count > 0
                    self.isDailyMatchesFetched = true
                }
            }
        }
    }
}

struct DiscoveryView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoveryView().environmentObject(mockDM())
    }
}
