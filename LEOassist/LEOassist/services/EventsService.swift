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
            let startDate = event.startDate
            let endDate = event.endDate
            return EventData(
                title: event.title,
                startDate: "\(startDate)",
                endDate: "\(endDate)",
                integrationId: event.id
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
    
    static func addSingleEvent(userProfile: Profile, event: EventData, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = URL(string: ApplicationSecrets.SAVE_SINGLE_EVENT_ENDPOINT)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       
        request.setValue("\(userProfile.email)", forHTTPHeaderField: "owner")
       
        
        let jsonData = try? JSONEncoder().encode(event)

        // Attach your data to the request
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    completion(.failure(error))
                } else if let httpResponse = response as? HTTPURLResponse {
                    let str = String(data: data ?? Data(), encoding: .utf8)
                    print("Received data:\n\(str ?? "")")

                    if httpResponse.statusCode == 201 {
                        completion(.success(()))
                    } else {
                        let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to create event"])
                        completion(.failure(error))
                    }
                }
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
    
    static func fetchEventsFromDay(owner: String, day: String,  completion: @escaping ([Event]) -> Void) {
        let encodedDay = encodeString(str: day)
        let encodedOwner = encodeString(str: owner)
        let url = URL(string: ApplicationSecrets.GET_ALL_EVENTS_FROM_DAY_ENDPOINT.replacing("{OWNER}", with: encodedOwner).replacing("{DATE}", with: encodedDay))!
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
    
    private static func encodeString(str: String) -> String{
        guard let encodedStr = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Error: Unable to percent-encode owner string")
            return ""
        }
        return encodedStr
    
    }
}
