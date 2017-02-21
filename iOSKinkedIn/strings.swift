//
//  strings.swift
//  iOSKinkedIn
//
//  Created by alice on 2/19/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation

func joinIds(_ ids: [Int]) -> String {
    return ids.map(String.init).joined(separator: ",")
}

func splitIds(_ str: String) -> [Int] {
    return str.characters.split(separator: ",")
        .map(String.init)
        .map{ (c) -> Int in return Int(c, radix: 10)! }
    
}

func joinStrings(_ strings: [String]) -> String {
    return strings.joined(separator: ",")
}

func splitStrings(_ str: String) -> [String] {
    return str.characters.split(separator: ",").map(String.init)
}
