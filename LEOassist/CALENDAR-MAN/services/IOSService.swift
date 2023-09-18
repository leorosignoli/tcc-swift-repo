import Foundation
import EventKit

class IOSService {
    let eventStore = EKEventStore()

    func getiOSCalendarData(completion: @escaping (EKEventStore, [EKEvent]?) -> Void) {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            completion(eventStore, getCalendarEvents(eventStore: eventStore))
        case .notDetermined:
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                if granted {
                    DispatchQueue.main.async {
                        let newEventStore = EKEventStore() // New instance after access granted
                        completion(newEventStore, self.getCalendarEvents(eventStore: newEventStore))
                    }
                }
            })
        default:
            print("Access denied")
        }
    }

    private func getCalendarEvents(eventStore: EKEventStore) -> [EKEvent]? {
        let startDate = Date().addingTimeInterval(-60*60*24) // 1 day before now
        let endDate = Date().addingTimeInterval(60*60*24*30) // 30 days after now
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let events = eventStore.events(matching: predicate)
        return events
    }
}
