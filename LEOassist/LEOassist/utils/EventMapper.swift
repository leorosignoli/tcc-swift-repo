//
//  EKEventMapper.swift
//  LEOassist
//
//  Created by Leonardo Andrade Rosignoli on 23/09/23.
//

import Foundation
import EventKit


class EventMapper{
    
    func mapToEvent(from ekEvent: EKEvent) -> Event {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" 

        let id = ekEvent.eventIdentifier
        let title = ekEvent.title ?? "Sem título"
        let startDate = dateFormatter.string(from: ekEvent.startDate)
        let endDate = dateFormatter.string(from: ekEvent.endDate)

        return Event(id: id!, title: title, startDate: startDate, endDate: endDate)
    }
    
    func mapToEvent(from msEvent: MicrosoftEvent) -> Event {
        let id = msEvent.id
        let title = msEvent.subject
        let startDate = msEvent.startDate
        let endDate = msEvent.endDate

        return Event(id: id, title: title, startDate: startDate, endDate: endDate)
    }
    
    func mapListToEvent(items: [EKEvent]) -> [Event] {
        return items.map(mapToEvent)
    }
    
    func mapListToEvent(items: [MicrosoftEvent]) -> [Event] {
        return items.map(mapToEvent)
    }
}
