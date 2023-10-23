//
//  ChatWorkflowService.swift
//  LEOassist
//
//  Created by Leonardo Andrade Rosignoli on 07/10/23.
//

import Foundation


class ChatWorkflowService {
    
    
    static func chatWithBot(conversation: [ChatMessage], owner: String, completion: @escaping ([ChatMessage]) -> Void) {
        let encodedOwner = encodeString(str: owner)
        guard let url = URL(string: ApplicationSecrets.EXCHANGE_MESSAGES_ENDPOINT.replacing("{OWNER}", with: encodedOwner)) else {
            print("Error: Unable to create URL")
            return
        }
        print("Making api call to: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        printChatMessagesAsJSON(messages: conversation)
        if let jsonData = try? encoder.encode(conversation) {
            request.httpBody = jsonData
        } else {
            print("Error: Unable to encode conversation to JSON")
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                let jsonString = String(data: data, encoding: .utf8)
                print("JSON data received: \(jsonString ?? "nil")")
                
                let decoder = JSONDecoder()
                do {
                    let events = try decoder.decode([ChatMessage].self, from: data)
                    DispatchQueue.main.async {
                        print("Retrieved events: \(events)")
                        completion(events)
                    }
                } catch {
                    print("Error decoding JSON data: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    static func printChatMessagesAsJSON(messages: [ChatMessage]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // Optional: for better readability of the printed JSON

        do {
            let jsonData = try encoder.encode(messages)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Chat messages as JSON:\n\(jsonString)")
            } else {
                print("Error: Unable to convert JSON data to string")
            }
        } catch {
            print("Error encoding chat messages to JSON: \(error.localizedDescription)")
        }
    }
    
    private static func encodeString(str: String) -> String{
        guard let encodedStr = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {
            print("Error: Unable to percent-encode owner string")
            return ""
            
        }
        return encodedStr
        
    }
    
}
