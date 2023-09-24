//
//  File.swift
//  LEOassist
//
//  Created by Leonardo Andrade Rosignoli on 23/09/23.
//

import SwiftUI
 
class OutlookService {
    
    let mapper = EventMapper()
    
    
    func fetchEvents(withToken token: String, completion: @escaping ([Event]?, Error?) -> Void) {
        let formatter = ISO8601DateFormatter()
        let currentDate = formatter.string(from: Date())

        print(currentDate)
        let url = URL(string: "https://graph.microsoft.com/v1.0/me/events?$filter=start/dateTime ge '\(currentDate)'")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        print("Starting fetch request for events...")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Fetch request failed with error: \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("No data received from fetch request.")
                completion(nil, error)
                return
            }
            if let responseBody = String(data: data, encoding: .utf8) {
                   print("Response Body: \(responseBody)")
               }
            do {
                let events = try JSONDecoder().decode(EventsResponse.self, from: data)
                print("Successfully fetched \(events.value.count) events.")
                completion(self.mapper.mapListToEvent(items: events.value), nil)
            } catch {
                print("Failed to decode events with error: \(error)")
                completion(nil, error)
            }
        }
        
        task.resume()
    }
}
