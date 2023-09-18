//
//  LEOassistApp.swift
//  LEOassist
//
//  Created by Leonardo Andrade Rosignoli on 06/09/23.
//

import SwiftUI

import AVKit

@main
struct LEOassistApp: App {
    
    @StateObject var userProfile = Profile.empty

    var body: some Scene {
        WindowGroup {
            NavigationView {
                LoginPageView()
                    .environmentObject(Profile.empty)


            }
        }
    }
    
}


