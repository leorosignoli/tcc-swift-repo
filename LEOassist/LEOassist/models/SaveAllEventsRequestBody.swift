//
//  SaveAllEventsRequestBody.swift
//  LEOassist
//
//  Created by Leonardo Andrade Rosignoli on 14/09/23.
//

import Foundation
import SwiftUI


struct EventData: Codable {
    var title: String
    var startDate: String
    var endDate: String
    var integrationId: String
}

struct EventRequest: Codable {
    var eventOwner: String
    var data: [EventData]
}
