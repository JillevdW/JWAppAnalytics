//
//  UserJourney.swift
//  JWAppAnalytics
//
//  Created by Jille van der Weerd on 13/05/2019.
//  Copyright © 2019 Jille van der Weerd. All rights reserved.
//

import Foundation

class UserJourney {
    
    let uuid: String
    var events: [[String: Any]]
    
    init(uuid: String, events: [[String: Any]]) {
        self.uuid = uuid
        self.events = events
    }
    
}
