//
//  ApplicationSecrets.swift
//  LEOassist
//
//  Created by Leonardo Andrade Rosignoli on 15/09/23.
//

import Foundation

struct ApplicationSecrets {
    
    private static let EC2_EVENT_MANAGEMENT_CLUSTER = "http://ec2-54-208-120-62.compute-1.amazonaws.com:8080"
    
    public static let SAVE_ALL_EVENTS_ENDPOINT = EC2_EVENT_MANAGEMENT_CLUSTER.appending("/events")
    
    public static let GET_ALL_EVENTS_ENDPOINT = EC2_EVENT_MANAGEMENT_CLUSTER.appending("/events?owner={OWNER}")
    
    public static let GET_ALL_EVENTS_FROM_DAY_ENDPOINT = EC2_EVENT_MANAGEMENT_CLUSTER.appending("/events?owner={OWNER}&startDate={DATE}")


    
}
