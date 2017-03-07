//
//  illusionist.swift
//  iOSKinkedIn
//
//  Created by alice on 3/3/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation

class ShadowUsers {
    
    var users = [Profile]()
    
    init(){
        let bo = Profile(neoId: "bo", name: "Bo", age: 32)
            bo.kinksMatched = 3
            bo.city = "New York, NY"
            bo.genders = ["Pangender", "Genderfluid"]
            bo.bio = "Born in Hel, Bo is the daughter of Hades and his prisoner Aife. She was taken away from her father's reach as an infant and left with a human couple that adopted and raised her. During her first sexual experience, she involuntarily killed her high school boyfriend by draining him of his Chi (life energy). Not knowing what she had done and why it had happened, Bo ran away from home. For ten years, before she was discovered by the Fae, she lived a life without friends or family, moving from place to place, and changing identities each time she killed again. It was not until she was helped by the Light Fae's human physician and scientist that she finally learned what she was and how to control her chi-draining powers."
        let dyson = Profile(neoId: "dyson", name: "Dyson", age: 35)
            dyson.kinksMatched = 4
            dyson.city = "New York, NY"
            dyson.genders = ["Bigender"]
        dyson.bio = "He is often short tempered and easily aggravated.\n\nDyson is fearlessly and unquestioningly loyal to his friends and displays a certain respect for rules and the law. However, he shows willingness to bend rules in order to serve his friends, particularly Bo.\n\nHe can sometimes be jealous and possessive (especially about Bo).\n\nLike all Wolf-Shifters, Dyson can shift completely into a wolf or partially. When he part-shifts, the nature of his eyes change and his teeth become lupine with fangs."
        let kenzi = Profile(neoId: "kenzi", name: "Kenzi", age: 22)
            kenzi.kinksMatched = 7
            kenzi.city = "New York, NY"
            kenzi.genders = ["Interxex"]
            kenzi.bio = "Kenzi is extremely protective of Bo and does not take kindly to anyone she considers as not having her BFF's best interests at heart. At times she has been rash and does not always make the best decisions, although never intentionally. She has become very close to Trick and seeks his advice often. She and Hale have become close, not only because both know what it's like to be the sidekick, but also from an underlying attraction towards each other. Her relationships with Dyson and Lauren are friendly but more guarded, due to the fact that both have at one time or another hurt Bo because of the romantic feelings she has for both of them."
        let hale = Profile(neoId: "hale", name: "Hale", age: 28)
            hale.kinksMatched = 2
            hale.city = "New York, NY"
            hale.genders = ["Two Spirit"]
            hale.bio = "He is a noble blood Baronet of Clan Zamora. Although Hale is of a high social status from a family that has significant importance among the Light Fae, he has generally ignored his social and political connections as he prefers to explore a life of his own rather than the traditional roles expected of his family."

        self.users = [bo, dyson, kenzi, hale]
    }
}
