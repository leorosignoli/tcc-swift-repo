// EventsService.swift
import Foundation

class EventsService {
    static func syncEvents(userProfile: Profile, events: Events, completion: @escaping () -> Void) {
        // Prepare your request
        let url = URL(string: ApplicationSecrets.SAVE_ALL_EVENTS_ENDPOINT)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Prepare your data
        let eventData = (events.items?.compactMap { event -> EventData? in
            guard let startDate = event.startDate, let endDate = event.endDate else { return nil }
            return EventData(
                title: event.title ?? "",
                startDate: "\(startDate)",
                endDate: "\(endDate)",
                integrationId: event.eventIdentifier
            )
        }) ?? []
        let eventRequest = EventRequest(eventOwner: userProfile.email, data: eventData)
        let jsonData = try? JSONEncoder().encode(eventRequest)

        // Attach your data to the request
        request.httpBody = jsonData

        // Make the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                let str = String(data: data, encoding: .utf8)
                print("Received data:\n\(str ?? "")")
            }
            completion()
        }
        task.resume()
    }
    
    
    static func fetchEvents(owner: String, completion: @escaping ([Event]) -> Void) {
            guard let encodedOwner = owner.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                print("Error: Unable to percent-encode owner string")
                return
            }
            let url = URL(string: ApplicationSecrets.GET_ALL_EVENTS_ENDPOINT.replacing("{OWNER}", with: encodedOwner))!
            print("Making api call to: \(url)")
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let data = data {
                    let decoder = JSONDecoder()
                    if let events = try? decoder.decode([Event].self, from: data) {
                        DispatchQueue.main.async {
                            print("Retrieved events: \(events)")
                            completion(events)
                        }
                    }
                }
            }.resume()
        }
}
