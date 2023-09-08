//
//  LEOassistApp.swift
//  LEOassist
//
//  Created by Leonardo Andrade Rosignoli on 06/09/23.
//

import SwiftUI

@main
struct LEOassistApp: App {
    
    @StateObject var userProfile = Profile.empty

    var body: some Scene {
        WindowGroup {
            NavigationView {
                LoginPageView() 


            }
        }
    }
}
