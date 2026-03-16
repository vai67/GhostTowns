import SwiftUI

struct TimelineView: View {
    @Binding var path: NavigationPath
    @State private var filter: String? = nil

    var filtered: [TimelineEvent] {
        guard let f = filter else { return TimelineEvent.all }
        return TimelineEvent.all.filter { $0.type == f }
    }

    var body: some View {
        ZStack {
            T.bg.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    BackBtn(label: "Home") { path.removeLast() }
                        .padding(.bottom, 24)

                    Eyebrow(text: "The Timeline").padding(.bottom, 10)

                    Text("How it happened.")
                        .font(fDisplay(36))
                        .foregroundStyle(T.cream)
                        .padding(.bottom, 10)

                    Text("Not in one act. Over three centuries, through law and force and broken agreements.")
                        .font(fBody(15))
                        .foregroundStyle(T.muted)
                        .lineSpacing(5)
                        .padding(.bottom, 22)

                    // filter chips — single row
                    HStack(spacing: 6) {
                        chip("All",      nil)
                        chip("Removal",  "removal")
                        chip("Treaties", "treaty")
                        chip("Recovery", "recovery")
                    }
                    .padding(.bottom, 28)

                    // vertical timeline
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(LinearGradient(colors: [.clear, T.rust.opacity(0.44), .clear],
                                                 startPoint: .top, endPoint: .bottom))
                            .frame(width: 1)
                            .padding(.leading, 13)

                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(Array(filtered.enumerated()), id: \.element.id) { i, event in
                                TimelineRow(event: event, index: i)
                                    .padding(.bottom, 26)
                            }
                        }
                    }

                    Spacer().frame(height: 100)
                }
                .padding(.horizontal, 28)
                .padding(.top, 56)
            }
        }
        .navigationBarHidden(true)
    }

    @ViewBuilder
    func chip(_ label: String, _ val: String?) -> some View {
        let active = filter == val
        Button { filter = val } label: {
            Text(label)
                .font(fLabel(11)).tracking(1)
                .foregroundStyle(active ? T.cream : T.gold)
                .padding(.horizontal, 10).padding(.vertical, 4)
                .background(active ? T.rust : T.rust.opacity(0.1))
                .overlay(RoundedRectangle(cornerRadius: 2).stroke(
                    active ? T.rust : T.rust.opacity(0.22), lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 2))
        }
    }
}

struct TimelineRow: View {
    let event: TimelineEvent
    let index: Int
    @State private var appeared = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        HStack(alignment: .top, spacing: 18) {
            ZStack {
                Circle().fill(event.typeColor.opacity(0.15)).frame(width:28,height:28)
                    .overlay(Circle().stroke(event.typeColor.opacity(0.55), lineWidth:1))
                Circle().fill(event.typeColor).frame(width:8,height:8)
            }
            .padding(.top, 2)

            VStack(alignment: .leading, spacing: 5) {
                Text(String(event.year)).font(fDisplay(22)).foregroundStyle(event.typeColor)
                Text(event.text).font(fBody(15)).foregroundStyle(T.muted).lineSpacing(5)
                Text(event.type.uppercased())
                    .font(fLabel(9)).tracking(3).foregroundStyle(event.typeColor)
                    .padding(.horizontal, 8).padding(.vertical, 2)
                    .overlay(RoundedRectangle(cornerRadius:2).stroke(event.typeColor.opacity(0.44), lineWidth:1))
                    .padding(.top, 4)
            }
        }
        .scaleEffect(appeared ? 1 : (reduceMotion ? 1 : 1.06))
        .opacity(appeared ? 1 : 0)
        .onAppear {
            withAnimation(.easeOut(duration: 0.4).delay(reduceMotion ? 0 : Double(index) * 0.05)) {
                appeared = true
            }
        }
    }
}
