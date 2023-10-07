//
//  ChatBubble.swift
//  LEOassist
//
//  Created by Leonardo Andrade Rosignoli on 07/10/23.
//

import Foundation
import SwiftUI


struct ChatBubble: Shape {
    var isUser: Bool

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: isUser ? [.topLeft, .bottomLeft, .bottomRight] : [.topLeft, .topRight, .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        return Path(path.cgPath)
    }
}
