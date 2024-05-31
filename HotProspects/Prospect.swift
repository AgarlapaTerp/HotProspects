//
//  Prospect.swift
//  HotProspects
//
//  Created by user256510 on 5/3/24.
//

import SwiftData

@Model
class Prospect {
    var name: String
    var emailAddress: String
    var isContacted: Bool
    
    init(name: String, emailAddress: String, isContacted: Bool) {
        self.name = name
        self.emailAddress = emailAddress
        self.isContacted = isContacted
    }
    
    static var example: Prospect {
        return Prospect(name: "Abhi", emailAddress: "noneyabusiness@gmail.com", isContacted: false)
    }
}
