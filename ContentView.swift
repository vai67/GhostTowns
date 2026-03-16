import SwiftUI

enum Route: Hashable {
    case scanner
    case nations
    case nation(Nation)
    case timeline
    case data

    static func == (lhs: Route, rhs: Route) -> Bool {
        switch (lhs, rhs) {
        case (.scanner,.scanner), (.nations,.nations), (.timeline,.timeline), (.data,.data): return true
        case (.nation(let a), .nation(let b)): return a.id == b.id
        default: return false
        }
    }
    func hash(into h: inout Hasher) {
        switch self {
        case .scanner:       h.combine(0)
        case .nations:       h.combine(1)
        case .nation(let n): h.combine(2); h.combine(n.id)
        case .timeline:      h.combine(3)
        case .data:          h.combine(4)
        }
    }
}

struct ContentView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            WelcomeView(path: $path)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .scanner:         ScannerView(path: $path)
                    case .nations:         NationsView(path: $path)
                    case .nation(let n):   NationDetailView(nation: n, path: $path)
                    case .timeline:        TimelineView(path: $path)
                    case .data:            DataView(path: $path)
                    }
                }
        }
        .tint(T.gold)
    }
}



