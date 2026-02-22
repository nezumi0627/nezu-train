//
//  TransitSearchView.swift
//  nezu-train
//
//  乗り換え案内検索画面。Liquid Glass デザイン。
//

import SwiftUI

struct TransitSearchView: View {
    @State private var departure = ""
    @State private var destination = ""
    @State private var date = Date()
    @State private var includeTypes: [TransitType: Bool] = [
        .bus: true,
        .shinkansen: true,
        .flight: true,
        .localTrain: true,
        .walk: true
    ]
    @State private var isSearching = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(colors: [.blue.opacity(0.3), .purple.opacity(0.2), .indigo.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("nezu-transit")
                                .font(.system(size: 40, weight: .black, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(colors: [.primary, .primary.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                                )
                            Text("次世代の乗り換え案内体験")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 20)

                        // Search Card
                        VStack(spacing: 16) {
                            HStack(spacing: 16) {
                                Image(systemName: "circle.fill")
                                    .font(.caption2)
                                    .foregroundStyle(.blue)
                                TextField("出発地 (例: 福岡空港)", text: $departure)
                                    .font(.body.weight(.medium))
                            }
                            .padding()
                            .glassEffect(in: .rect(cornerRadius: 12))
                            
                            HStack(spacing: 16) {
                                Image(systemName: "arrow.down")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Button {
                                    let temp = departure
                                    departure = destination
                                    destination = temp
                                } label: {
                                    Image(systemName: "arrow.up.arrow.down")
                                        .font(.system(size: 14, weight: .bold))
                                        .padding(8)
                                        .glassEffect(in: .circle)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            HStack(spacing: 16) {
                                Image(systemName: "mappin.and.ellipse")
                                    .font(.caption2)
                                    .foregroundStyle(.red)
                                TextField("到着地 (例: 東京駅)", text: $destination)
                                    .font(.body.weight(.medium))
                            }
                            .padding()
                            .glassEffect(in: .rect(cornerRadius: 12))
                        }
                        .padding(.horizontal, 20)

                        // Options Card
                        VStack(spacing: 16) {
                            DatePicker("出発日時", selection: $date, displayedComponents: [.date, .hourAndMinute])
                                .font(.subheadline)
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("利用する交通手段")
                                    .font(.caption.bold())
                                    .foregroundStyle(.secondary)
                                
                                FlowLayout(spacing: 8) {
                                    ForEach(TransitType.allCases, id: \.self) { type in
                                        Toggle(isOn: Binding(
                                            get: { includeTypes[type] ?? false },
                                            set: { includeTypes[type] = $0 }
                                        )) {
                                            Label(type.rawValue, systemImage: iconForType(type))
                                        }
                                        .toggleStyle(.button)
                                        .buttonStyle(.bordered)
                                        .tint(colorForType(type))
                                    }
                                }
                            }
                        }
                        .padding()
                        .glassEffect(in: .rect(cornerRadius: 20))
                        .padding(.horizontal, 20)

                        // Search Button
                        Button {
                            isSearching = true
                        } label: {
                            Text("ルートを検索")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(colors: [.blue, .indigo], startPoint: .leading, endPoint: .trailing)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .padding(.horizontal, 20)
                        
                        // Recent Searches
                        VStack(alignment: .leading, spacing: 16) {
                            Text("最近の検索")
                                .font(.headline)
                                .padding(.horizontal, 24)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    RecentSearchItem(title: "小倉 → 東京", sub: "バス + 飛行機")
                                    RecentSearchItem(title: "博多 → 大阪", sub: "新幹線")
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            .navigationDestination(isPresented: $isSearching) {
                SearchResultView(departure: departure, destination: destination, includeTypes: includeTypes)
            }
        }
    }
    
    func iconForType(_ type: TransitType) -> String {
        switch type {
        case .shinkansen: return "train.side.front.car"
        case .bus: return "bus.fill"
        case .flight: return "airplane"
        case .localTrain: return "train.side.middle.car"
        case .walk: return "figure.walk"
        }
    }
    
    func colorForType(_ type: TransitType) -> Color {
        switch type {
        case .shinkansen: return .blue
        case .bus: return .green
        case .flight: return .purple
        case .localTrain: return .orange
        case .walk: return .secondary
        }
    }
}

struct RecentSearchItem: View {
    let title: String
    let sub: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.body.weight(.semibold))
            Text(sub)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .glassEffect(in: .rect(cornerRadius: 16))
    }
}

// Glass Effect utility (reusing from previous work or defining if missing)
extension View {
    func glassEffect(in shape: some Shape = .rect) -> some View {
        self.background(.ultraThinMaterial, in: shape)
            .overlay(
                shape.stroke(.white.opacity(0.2), lineWidth: 0.5)
            )
    }
}

struct SearchResultView: View {
    let departure: String
    let destination: String
    let includeTypes: [TransitType: Bool]
    @StateObject private var engine = TransitEngine()
    @StateObject private var activityManager = LiveActivityManager()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.1), .purple.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    if engine.routes.isEmpty {
                        ProgressView("検索中...")
                            .padding(.top, 40)
                    } else {
                        ForEach(engine.routes) { route in
                            NavigationLink {
                                RouteDetailView(route: route)
                                    .environmentObject(activityManager)
                            } label: {
                                RouteResultCard(route: route)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("\(departure) → \(destination)")
        .onAppear {
            engine.search(from: departure, to: destination, includeTypes: includeTypes)
        }
    }
}

struct RouteResultCard: View {
    let route: Route
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: -8) {
                    ForEach(route.segments) { segment in
                        Image(systemName: segment.icon)
                            .font(.caption)
                            .padding(6)
                            .background(segment.color.opacity(0.2))
                            .foregroundStyle(segment.color)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(.background, lineWidth: 2))
                    }
                }
                
                Spacer()
                
                Text("\(route.price)円")
                    .font(.headline)
            }
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(route.timeString)
                        .font(.title3.bold())
                    Text("\(route.totalMinutes)分")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text(route.segments.map { $0.title }.joined(separator: " → "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding()
        .glassEffect(in: .rect(cornerRadius: 20))
    }
}

struct RouteDetailView: View {
    let route: Route
    @EnvironmentObject var activityManager: LiveActivityManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Details
                VStack(spacing: 16) {
                    Text(route.timeString)
                        .font(.largeTitle.bold())
                    
                    HStack(spacing: 20) {
                        DetailStat(label: "所要時間", value: "\(route.totalMinutes)分", icon: "clock")
                        DetailStat(label: "料金", value: "\(route.price)円", icon: "yensign.circle")
                        DetailStat(label: "乗換", value: "\(route.segments.count - 1)回", icon: "arrow.left.arrow.right")
                    }
                }
                .padding()
                .glassEffect(in: .rect(cornerRadius: 24))
                .padding(.horizontal)

                // Timeline
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(0..<route.segments.count, id: \.self) { index in
                        let segment = route.segments[index]
                        
                        TimelineNode(time: formatDate(segment.departureTime), 
                                     title: segment.start.name, 
                                     platform: segment.subTitle ?? "", 
                                     isStart: index == 0)
                        
                        TimelineNode(time: "", 
                                     title: segment.title, 
                                     platform: segment.flightNumber != nil ? "Flight: \(segment.flightNumber!)" : "", 
                                     isTransit: true, 
                                     color: segment.color)
                        
                        if index == route.segments.count - 1 {
                            TimelineNode(time: formatDate(segment.arrivalTime), 
                                         title: segment.end.name, 
                                         platform: "", 
                                         isEnd: true)
                        }
                    }
                }
                .padding()
                .glassEffect(in: .rect(cornerRadius: 24))
                .padding(.horizontal)

                // Tracking Button
                Button {
                    activityManager.startTracking(route: route)
                } label: {
                    HStack {
                        Image(systemName: "timer")
                        Text("トラッキングを開始 (Live Activity)")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .clipShape(Capsule())
                }
                .padding(.horizontal, 24)
                
                if activityManager.currentActivityId != nil {
                    Button {
                        activityManager.stopTracking()
                    } label: {
                        Text("トラッキングを停止")
                            .foregroundStyle(.red)
                    }
                }
            }
            .padding(.bottom, 40)
        }
        .navigationTitle("ルート詳細")
    }
    
    func formatDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: date)
    }
}

struct DetailStat: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let _ = layout(proposal: proposal, subviews: subviews, bounds: bounds)
    }
    
    private func layout(proposal: ProposedViewSize, subviews: Subviews, bounds: CGRect? = nil) -> (size: CGSize, lastHeight: CGFloat) {
        var x: CGFloat = bounds?.minX ?? 0
        var y: CGFloat = bounds?.minY ?? 0
        var maxWidth: CGFloat = 0
        var maxHeight: CGFloat = 0
        let proposalWidth = proposal.width ?? .infinity
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > proposalWidth && x > (bounds?.minX ?? 0) {
                x = bounds?.minX ?? 0
                y += maxHeight + spacing
                maxHeight = 0
            }
            
            if let bounds = bounds {
                subview.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
            }
            
            x += size.width + spacing
            maxWidth = max(maxWidth, x)
            maxHeight = max(maxHeight, size.height)
        }
        
        return (CGSize(width: maxWidth, height: y + maxHeight), maxHeight)
    }
}

struct TimelineNode: View {
    let time: String
    let title: String
    let platform: String
    var isStart = false
    var isTransit = false
    var isEnd = false
    var color: Color = .primary
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack {
                Text(time)
                    .font(.system(.caption, design: .monospaced))
                    .frame(width: 45)
                Spacer()
            }
            
            VStack(spacing: 0) {
                if isTransit {
                    Rectangle()
                        .fill(color)
                        .frame(width: 2, height: 10)
                } else {
                    Circle()
                        .stroke(color, lineWidth: 2)
                        .background(Circle().fill(.background))
                        .frame(width: 12, height: 12)
                }
                
                if !isEnd {
                    Rectangle()
                        .fill(isTransit ? color : .primary)
                        .frame(width: 2, height: isTransit ? 60 : 20)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body.weight(isTransit ? .regular : .bold))
                if !platform.isEmpty {
                    Text(platform)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                if isTransit {
                    Spacer(minLength: 40)
                }
            }
            Spacer()
        }
    }
}

struct ResultCard: View {
    let title: String
    let time: String
    let price: String
    let type: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(type, systemImage: icon)
                    .font(.caption.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(color.opacity(0.2))
                    .foregroundStyle(color)
                    .clipShape(Capsule())
                
                Spacer()
                
                Text(price)
                    .font(.headline)
            }
            
            Text(title)
                .font(.title3.bold())
            
            HStack {
                Image(systemName: "clock")
                Text(time)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding()
        .glassEffect(in: .rect(cornerRadius: 20))
    }
}

#Preview {
    TransitSearchView()
}
