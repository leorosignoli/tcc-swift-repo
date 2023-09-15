//
//  Event.swift
//  LEOassist
//
//  Created by Leonardo Andrade Rosignoli on 09/09/23.
//

import Foundation

struct CreateEventsClientRequestBody: Encodable {
    let title: String
    let startDate: Date
    let endDate: Date
}


struct Event: Codable, Identifiable {
    let id: String
    let title: String
    let startDate: String
    let endDate: String
}
