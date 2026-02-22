import Foundation
import SwiftUI

// MARK: - Models

struct Route: Identifiable, Codable {
    let id: UUID
    let departureTime: Date
    let arrivalTime: Date
    let totalMinutes: Int
    let price: Int
    let segments: [Segment]
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return "\(formatter.string(from: departureTime)) - \(formatter.string(from: arrivalTime))"
    }
}

struct Segment: Identifiable, Codable {
    let id = UUID()
    let type: TransitType
    let start: Stop
    let end: Stop
    let departureTime: Date
    let arrivalTime: Date
    let title: String
    let subTitle: String?
    let flightNumber: String? // for flight
    var status: String? // "On Time", "Delayed", etc.
    let price: Int
    
    var color: Color {
        switch type {
        case .shinkansen: return .blue
        case .bus: return .green
        case .flight: return .purple
        case .localTrain: return .orange
        case .walk: return .secondary
        }
    }
    
    var icon: String {
        switch type {
        case .shinkansen: return "train.side.front.car"
        case .bus: return "bus.fill"
        case .flight: return "airplane"
        case .localTrain: return "train.side.middle.car"
        case .walk: return "figure.walk"
        }
    }
}

struct Stop: Codable {
    let name: String
    let lat: Double?
    let lon: Double?
    let isAirport: Bool
}

enum TransitType: String, Codable, CaseIterable {
    case shinkansen = "新幹線"
    case bus = "バス"
    case flight = "飛行機"
    case localTrain = "一般交通"
    case walk = "徒歩"
}

// MARK: - Engine

class TransitEngine: ObservableObject {
    @Published var routes: [Route] = []
    
    func search(from: String, to: String, includeTypes: [TransitType: Bool]) {
        // Mock data logic reflecting the combination of transport
        let now = Date()
        
        var mockRoutes: [Route] = []
        
        // Route 1: Bus + Flight + Shinkansen
        if includeTypes[.bus] ?? true && includeTypes[.flight] ?? true && includeTypes[.shinkansen] ?? true {
            let s1 = Segment(type: .bus, start: Stop(name: "小倉駅", lat: 0, lon: 0, isAirport: false), end: Stop(name: "北九州空港", lat: 0, lon: 0, isAirport: true), departureTime: now.addingTimeInterval(600), arrivalTime: now.addingTimeInterval(3000), title: "北九州空港エアポートバス", subTitle: "2番乗り場", flightNumber: nil, status: "定刻", price: 700)
            
            let s2 = Segment(type: .flight, start: Stop(name: "KKJ", lat: 0, lon: 0, isAirport: true), end: Stop(name: "HND", lat: 0, lon: 0, isAirport: true), departureTime: now.addingTimeInterval(4500), arrivalTime: now.addingTimeInterval(10000), title: "JAL 374便", subTitle: "北九州 → 羽田", flightNumber: "JL374", status: "On Time", price: 15000)
            
            let s3 = Segment(type: .shinkansen, start: Stop(name: "品川駅", lat: 0, lon: 0, isAirport: false), end: Stop(name: "東京駅", lat: 0, lon: 0, isAirport: false), departureTime: now.addingTimeInterval(11000), arrivalTime: now.addingTimeInterval(11600), title: "のぞみ 12号", subTitle: "自由席", flightNumber: nil, status: "定刻", price: 1000)
            
            mockRoutes.append(Route(id: UUID(), departureTime: s1.departureTime, arrivalTime: s3.arrivalTime, totalMinutes: 183, price: 16700, segments: [s1, s2, s3]))
        }
        
        // Route 2: Shinkansen focus
        if includeTypes[.shinkansen] ?? true {
            let s1 = Segment(type: .shinkansen, start: Stop(name: "小倉駅", lat: 0, lon: 0, isAirport: false), end: Stop(name: "東京駅", lat: 0, lon: 0, isAirport: false), departureTime: now.addingTimeInterval(1200), arrivalTime: now.addingTimeInterval(21000), title: "のぞみ 2号", subTitle: "10番線", flightNumber: nil, status: "5分遅れ", price: 21000)
            
            mockRoutes.append(Route(id: UUID(), departureTime: s1.departureTime, arrivalTime: s1.arrivalTime, totalMinutes: 330, price: 21000, segments: [s1]))
        }
        
        self.routes = mockRoutes
    }
}
