//
//  LiveActivityManager.swift
//  nezu-train
//

import ActivityKit
import Foundation

class LiveActivityManager: ObservableObject {
    @Published var currentActivityId: String? = nil
    
    func startTracking(route: Route) {
        let firstSegment = route.segments.first
        let attributes = TransitActivityAttributes(
            trainName: firstSegment?.title ?? "予定の旅",
            transportIcon: firstSegment?.icon ?? "tram.fill"
        )
        
        let initialContentState = TransitActivityAttributes.ContentState(
            currentStation: firstSegment?.start.name ?? "出発",
            nextStation: firstSegment?.end.name ?? "目的地",
            progress: 0.1,
            arrivalTime: route.arrivalTime,
            statusText: "定刻通り運行中",
            flightStatus: firstSegment?.status
        )
        
        do {
            let activity = try Activity.request(
                attributes: attributes,
                content: .init(state: initialContentState, staleDate: nil)
            )
            print("Activity started: \(activity.id)")
            self.currentActivityId = activity.id
        } catch {
            print("Error starting activity: \(error.localizedDescription)")
        }
    }
    
    func stopTracking() {
        Task {
            for activity in Activity<TransitActivityAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
            self.currentActivityId = nil
        }
    }
}
