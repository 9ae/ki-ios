//
//  ConvoUI.swift
//  iOSKinkedIn
//
//  Created by Alice on 1/25/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct ConvoUI: View {
    var profile : Profile
    
    var body: some View {
        Text("Hey \(profile.name)! \n hfdkfj dsfjsldfjsdlfj sdlkfj  fdhflk dljks flkkfjfjf Use this property to specify a footer view for your entire table. The footer view is the last item to appear in the table's view's scrolling content, and it is separate from the footer views you add to individual sections. The default value of this property is nil. When assigning a view to this property, set the height of your view to a nonzero value. The table view respects only the height of your view's frame rectangle; it adjusts the width of your footer view automatically to match the table view's width.")
        
    }
}

@available(iOS 13.0.0, *)
struct ConvoUI_Previews: PreviewProvider {
    static var previews: some View {
        ConvoUI(profile: mockProfile)
    }
}
