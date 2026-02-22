//
//  TransitActivityAttributes.swift
//  nezu-train
//

import ActivityKit
import Foundation

struct TransitActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic data
        var currentStation: String
        var nextStation: String
        var progress: Double // 0.0 to 1.0
        var arrivalTime: Date
        var statusText: String
        var flightStatus: String? // for flight segments
    }

    // Static data
    var trainName: String
    var transportIcon: String
}
