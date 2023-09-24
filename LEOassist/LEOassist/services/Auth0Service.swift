//
//  Auth0Service.swift
//  LEOassist
//
//  Created by Leonardo Andrade Rosignoli on 24/09/23.
//

import Foundation
import SwiftUI
import Auth0

struct Auth0Service{
    
    @EnvironmentObject var userProfile : Profile
    
    public func logout() {
        Auth0
          .webAuth()
          .clearSession { result in
            
            switch result {
              
              case .failure(let error):
                print("Failed with: \(error)")
              
              case .success:
                self.userProfile.clearCredentials()
              
            } // switch
            
          } // clearSession()
      }

}
