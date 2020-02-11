//
//  Mocks.swift
//  iOSKinkedIn
//
//  Created by Alice on 1/25/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import Foundation

let mockProfile = Profile(uuid: "11675dce-b6a7-4b0c-acc0-3d28f72ca905", name: "Test Kenzi", age: 29, picture_public_id: "95f2176b-5369-42b3-9bab-bc6494361c76")


let mockAftercareFlow =
    CareQuestion("How are you feeling about your date?", type: .choice, followup: [
        CareQuestion("Awesome!", type: .option, followup: [
            CareQuestion("We are so excited to hear that! We hope you continue to have a great time!", type: .statement, followup: [])]),
        CareQuestion("Pretty good", type: .option, followup: [
            CareQuestion("Ok! We’re glad you’re doing alright.", type: .statement, followup:[
                CareQuestion("Is there anything that could have taken this from good to great?", type: .question, followup: [
                    CareQuestion("That's awesome, let's keep that in mind next time", type: .statement, followup: [])
                ])
            ] )]),
        CareQuestion("Just ok. I could be better", type: .option, followup: []),
        CareQuestion("Not okay. I need help", type: .option, followup: [])
        
    ])
