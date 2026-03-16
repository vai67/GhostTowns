import SwiftUI

struct WelcomeView: View {
    @Binding var path: NavigationPath
    @State private var appeared = false

    var body: some View {
        ZStack {
            Color(hex: "#0F0A06")!.ignoresSafeArea()
            MapBg()
            // dark overlay so map doesn't distract
            Color(hex: "#0F0A06")!.opacity(0.55).ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                

                // eyebrow — sits slightly above headline
                Text("GhostTowns · Ancestral Lands")
                    .font(fLabel(10)).tracking(5).textCase(.uppercase)
                    .foregroundStyle(T.gold.opacity(0.75))
                    .padding(.bottom, 18)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.1), value: appeared)

                // headline
                VStack(alignment: .leading, spacing: 0) {
                    Text("Discover the history")
                        .font(fDisplay(54))
                        .foregroundStyle(T.cream)
                    Text("beneath you.")
                        .font(fDisplay(54, italic: true))
                        .foregroundStyle(T.gold)
                }
                .lineSpacing(2)
                .shadow(color: .black.opacity(0.9), radius: 12, y: 2)
                .padding(.bottom, 14)
                .offset(y: appeared ? 0 : 20).opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.7).delay(0.2), value: appeared)

                // subtitle
                Text("Scan your surroundings to learn which nations have lived here across time.")
                    .font(fBody(16))
                    .foregroundStyle(T.muted)
                    .lineSpacing(5)
                    .frame(maxWidth: 310, alignment: .leading)
                    .padding(.bottom, 20)
                    .offset(y: appeared ? 0 : 20).opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.38), value: appeared)

                // stats row
                HStack(spacing: 0) {
                    ForEach([("96%","tribal land stolen"),("574","nations survive"),("1.5B","acres taken")], id:\.0) { val, lbl in
                        VStack(spacing: 4) {
                            Text(val).font(fDisplay(34)).foregroundStyle(T.gold)
                            Text(lbl).font(fLabel(13)).tracking(1).foregroundStyle(T.faint)
                                .multilineTextAlignment(.center)
                        }.frame(maxWidth: .infinity)
                    }
                }
                .padding(.bottom, 28)
                .offset(y: appeared ? 0 : 20).opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.5), value: appeared)

                // buttons
                VStack(spacing: 10) {
                    EarthBtn(label: "⊕   Open the Land Scanner") { path.append(Route.scanner) }
                    HStack(spacing: 8) {
                        GhostBtn(label: "◈  Nations")  { path.append(Route.nations) }
                        GhostBtn(label: "◉  Timeline") { path.append(Route.timeline) }
                        GhostBtn(label: "✦  The Land") { path.append(Route.data) }
                    }
                }
                .offset(y: appeared ? 0 : 20).opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.62), value: appeared)

                Spacer().frame(height: 24)

                Text("Built with reverence for the 574 federally recognized tribes and the hundreds more still seeking recognition.")
                    .font(fBody(13))
                    .foregroundStyle(T.faint)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 1).delay(0.8), value: appeared)
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 32)
        }
        .onAppear { appeared = true }
        .navigationBarHidden(true)
    }
}
