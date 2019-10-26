//
//  Case.swift
//  iOSKinkedIn
//
//  Created by Alice on 10/26/19.
//  Copyright © 2019 KinkedIn. All rights reserved.
//

import Foundation

enum CaseType : String {
    case report  = "report"
    case checkin = "checkin"
}

enum CaseStatus : String {
    case active = "active"
    case resolved = "resolved"
}

struct Case {
    var name: String
    var convo: String
    var caseType: CaseType
    var status: CaseStatus
    var updatedAt: String
}

extension Case {
    init?(_ json: [String: Any]){
        if let _name  = json["about_user_name"] as? String,
            let _convo = json["convo_uuid"] as? String,
            let _case = json["case_type"] as? String,
            let _resolved = json["resolved"] as? Bool,
            let _updateAt = json["updated_at"] as? String {
            self.name = _name
            self.convo = _convo
            self.updatedAt = _updateAt
            if _case == "checkin" {
                self.caseType = .checkin
            } else {
                self.caseType = .report
            }
            if _resolved {
                self.status = .resolved
            } else {
                self.status = .active
            }
        } else {
            return nil
        }
    }
}
