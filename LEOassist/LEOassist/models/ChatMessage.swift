//
//  ChatMessage.swift
//  LEOassist
//
//  Created by Leonardo Andrade Rosignoli on 07/10/23.
//

import Foundation
struct ChatMessage: Identifiable, Codable {
    var id: UUID?
    var content: String?
    var role: String
    var name: String?
    var function_call: FunctionCall?

    init(content: String, role: String) {
        self.id = UUID()
        self.content = content
        self.role = role
    }

    enum CodingKeys: String, CodingKey {
        case id
        case content
        case role
        case name
        case function_call
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        content = (try? container.decode(String.self, forKey: .content)) ?? ""
        name = (try? container.decode(String.self, forKey: .name)) 
        role = try container.decode(String.self, forKey: .role)
        function_call = try? container.decode(FunctionCall.self, forKey: .function_call)
    }
}

struct FunctionCall: Codable {
    let name: String
    let arguments: [String: String]
}
