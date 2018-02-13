//
//  constantine.swift
//  iOSKinkedIn
//
//  Created by alice on 6/28/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation

let UD_CHECKIN_TIME = "checkinTime"
let UD_CHECKIN_TIME_VALUE = 12

let UD_MATCH_LIMIT = "matchLimit"
let UD_MATCH_LIMIT_VALUE = 7

let UD_MATCHES_TODAY = "matchesToday"
let UD_MATCHES_TODAY_VALUE = 0

let UD_CAN_LIKE = "canLike"
let UD_CAN_LIKE_VALUE = true

enum ActionOnUser : Int {
    case skip = 0, like, block
}
