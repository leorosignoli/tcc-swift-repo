//
//  LEOassistApp.swift
//  LEOassist
//
//  Created by Leonardo Andrade Rosignoli on 06/09/23.
//

import SwiftUI
import MSAL

@main
struct LEOassistApp: App {
    
    @StateObject var userProfile = Profile.empty

    init() {
        setupMSALLogger()
    }

    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LoginPageView()
                    .environmentObject(Profile.empty)


            }
        }
    }
    
    
    func setupMSALLogger() {
        MSALGlobalConfig.loggerConfig.setLogCallback { (logLevel, message, containsPII) in
            if let displayableMessage = message {
//                if (!containsPII) {
//                    #if DEBUG
                    print(displayableMessage)
//                    #endif
//                }
            }
        }
    }
    
}


