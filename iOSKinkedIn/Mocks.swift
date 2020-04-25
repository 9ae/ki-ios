//
//  Mocks.swift
//  iOSKinkedIn
//
//  Created by Alice on 1/25/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import Foundation

let mockProfile = Profile(uuid: "11675dce-b6a7-4b0c-acc0-3d28f72ca905", name: "Test Kenzi", age: 29, picture_public_id: "95f2176b-5369-42b3-9bab-bc6494361c76")

let mockProfile2 = Profile(uuid: "5aad1438-5506-41b5-88a7-369ffa184502", name: "Test Demo 2", age: 32, picture_public_id: "f2e2f199-3a7c-4392-82a1-dcc796c74bb9")

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

func mockFullProfile() -> Profile {
    let pro = mockProfile
    pro.vouches = 3
    pro.kinksMatched = 6
    
    pro.city = "New York"
    pro.genders = ["agender", "androgynous", "bigender", "cisman", "ciswoman", "gender non-conforming", "genderfluid", "hijra", "intersex", "man", "non-binary", "other", "pangender", "trans man", "trans woman", "transfeminine", "transgender", "transmasculine", "transsexual", "two spirit", "woman"]
    pro.roles = ["domme", "exhibitionist", "masochist"]
    pro.bio = "Lorem ipsum. blah bha. | He's not like the other guys. He's a NICE guy -- but wait, is he really that nice? What's behind his sweet, romantic act? In this video, we take on the Nice Guy archetype and figure out what he represents in our world today."
    pro.kinks =
        [ Kink(label: "leather", code: "leather", form: .wearable, exp: 3, way: .give),
          Kink(label: "biting", code: "bite", form: .service, exp: 2,  way: .get),
          Kink(label: "exhibitionism", code: "exhibition", form: .act, exp: 2,  way: .both),
          Kink(label: "bondage", code: "bond", form:.service, exp: 3, way: .give)
        ]
    
    pro.prompts =
        [BioPrompt(title: "I am really good at...", answer: "making breakfast", show: true),
         BioPrompt(title: "I spend my days thinking about...", answer: "soccer", show: false),
         BioPrompt(title: "My safe word is...", answer: "penguin", show: true)
        ]
    return pro
}

let mockKinksOmake = [
    Kink(label: "masks" , code: "mask", form: .wearable, exp: 0, way: .none),
    Kink(label: "leather" , code: "leather", form: .wearable, exp: 0, way: .none),
    Kink(label: "corsets" , code: "corsets", form: .wearable, exp: 0, way: .none),
    Kink(label: "vibrators" , code: "vibrators", form: .accessory, exp: 0, way: .none),
    Kink(label: "intelligence", code: "intelligence", form: .aphrodisiac, exp: 0, way: .none)
]

let mockKinksActs = [
    Kink(label: "breath play", code: "breath", form: .act, exp: 0, way: .none),
    Kink(label: "double penetration", code: "ddp", form: .act, exp: 0, way: .none),
    Kink(label: "exhibitionism", code: "exhibition", form: .act, exp: 0, way: .none),
    Kink(label: "outdoor sex", code: "outdoorsex", form: .act, exp: 0, way: .none),
    Kink(label: "role play", code: "roleplay", form: .act, exp: 0, way: .none),
    Kink(label: "power exchange", code: "powerex", form: .act, exp: 0, way: .none),
    Kink(label: "voyeurism", code: "voyeur", form: .act, exp: 0, way: .none)
]

let mockKinksService = [
    Kink(label: "begging", code: "beg", form: .service, exp: 0, way: .none),
    Kink(label: "biting", code: "bite", form: .service, exp: 0, way: .none),
    Kink(label: "bondage", code: "bond", form: .service, exp: 0, way: .none),
    Kink(label: "caging/confinement", code: "cage", form: .service, exp: 0, way: .none),
    Kink(label: "candle wax", code: "candlewax", form: .service, exp: 0, way: .none),
    Kink(label: "choking", code: "choke", form: .service, exp: 0, way: .none),
    Kink(label: "fisting", code: "fist", form: .service, exp: 0, way: .none),
    Kink(label: "flogging", code: "flog", form: .service, exp: 0, way: .none),
    Kink(label: "orgasm control", code: "orgasmctrl", form: .service, exp: 0, way: .none),
    Kink(label: "spanking", code: "spank", form: .service, exp: 0, way: .none),
    Kink(label: "whipping", code: "whipping", form: .service, exp: 0, way: .none)
]

/* mock dungeon */
func mockDM () -> Dungeon {
    let dm = Dungeon()
    
    dm.discoverProfiles = [mockProfile, mockProfile2]
    dm.dailyMatches = [mockProfile]
    
    dm.genders = ["agender", "andrygynous", "bigender", "cisman", "ciswoman", "gender non-conforming", "genderfluid", "hijra", "intersex", "man", "non-binary", "other", "pangender", "trans man", "trans woman", "transfeminine", "transgender", "transmasculine", "transsexual", "two spirit", "woman"]
    dm.roles = ["bottom", "dominant", "domme", "evolving", "exhibitionist", "exploring", "hedonist", "kinkster", "masochist", "master", "mistress", "sadist", "sadomasochist", "sensualist", "slave", "submissive", "swinger", "switch", "top", "voyeur"]
    
    dm.kinksAct = mockKinksActs
    dm.kinksService = mockKinksService
    dm.kinksOmake = mockKinksOmake
    dm.allProfiles["myself"] = mockFullProfile()
    dm.myPhoneNumber = "212-123-1999"
    
    return dm
}
