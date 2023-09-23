//
//  MicrosoftEventsResponse.swift
//  LEOassist
//
//  Created by Leonardo Andrade Rosignoli on 23/09/23.
//

import Foundation


struct EventsResponse: Codable {
    let value: [MicrosoftEvent]
    
    func getValue() -> [MicrosoftEvent] {
        return value
    }
}


struct DateTime: Codable {
    let dateTime: String
    let timeZone: String
}

struct MicrosoftEvent: Codable, Identifiable {
    let id: String
    let subject: String
    let start: DateTime
    let end: DateTime

    var startDate: String {
        return start.dateTime
    }

    var endDate: String {
        return end.dateTime
    }
}
