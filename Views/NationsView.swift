import SwiftUI

struct NationsView: View {
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            T.bg.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    BackBtn(label: "Home") { path.removeLast() }
                        .padding(.bottom, 24)

                    Eyebrow(text: "The Nations").padding(.bottom, 10)

                    Text("They were\nhere first.")
                        .font(fDisplay(38))
                        .foregroundStyle(T.cream)
                        .lineSpacing(2).padding(.bottom, 10)

                    Text("Six of the hundreds of sovereign nations whose land became the United States. Not were. Are.")
                        .font(fBody(15))
                        .foregroundStyle(T.muted)
                        .lineSpacing(5).padding(.bottom, 28)

                    HR().padding(.bottom, 20)

                    ForEach(Nation.all) { nation in
                        Button { path.append(Route.nation(nation)) } label: {
                            NationCard(nation: nation)
                        }
                        .buttonStyle(.plain)
                        .padding(.bottom, 12)
                    }

                    Spacer().frame(height: 100)
                }
                .padding(.horizontal, 28)
                .padding(.top, 56)
            }
        }
        .navigationBarHidden(true)
    }
}

struct NationCard: View {
    let nation: Nation
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(nation.name).font(fDisplay(24)).foregroundStyle(T.cream)
                    Text(nation.also).font(fBody(12, italic: true)).foregroundStyle(T.faint)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(nation.population).font(fDisplay(20)).foregroundStyle(T.gold)
                    Text("people today").font(fLabel(10)).foregroundStyle(T.faint)
                }
            }
            .padding(.bottom, 10)

            RegionBadge(text: nation.region, color: nation.color).padding(.bottom, 10)
            Rectangle().fill(nation.color.opacity(0.2)).frame(height: 1).padding(.bottom, 10)
            Text(nation.presentDay).font(fBody(13)).foregroundStyle(T.faint)
        }
        .padding(18)
        .background(nation.color.opacity(0.05))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(nation.color.opacity(0.2), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct NationDetailView: View {
    let nation: Nation
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            T.bg.ignoresSafeArea()
            LinearGradient(
                colors: [nation.color.opacity(0.12), T.bg],
                startPoint: .init(x: 0.2, y: 0), endPoint: .init(x: 1, y: 0.5))
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    BackBtn(label: "All Nations") { path.removeLast() }
                        .padding(.bottom, 22)

                    RegionBadge(text: nation.region, color: nation.color).padding(.bottom, 12)

                    Text(nation.name)
                        .font(fDisplay(48))
                        .foregroundStyle(T.cream)
                        .minimumScaleFactor(0.7)
                        .padding(.bottom, 6)

                    Text(nation.also)
                        .font(fBody(14, italic: true))
                        .foregroundStyle(T.faint)
                        .padding(.bottom, 24)

                    // quote with left bar
                    HStack(alignment: .top, spacing: 0) {
                        Rectangle()
                            .fill(nation.color)
                            .frame(width: 3)
                            .clipShape(RoundedRectangle(cornerRadius: 2))
                        Text("\u{201C}\(nation.quote)\u{201D}")
                            .font(fBody(17, italic: true))
                            .foregroundStyle(T.cream.opacity(0.88))
                            .lineSpacing(6)
                            .padding(.leading, 16)
                    }
                    .padding(.bottom, 28)

                    sectionBlock("Their Land",     nation.land,     nation.color)
                    sectionBlock("What Was Taken", nation.removal,  nation.color)
                    sectionBlock("Their Language", nation.language, nation.color)
                    sectionBlock("The Treaty",     nation.treaty,   nation.color)

                    HStack(spacing: 10) {
                        statTile(nation.population, "People today",       nation.color)
                        statTile(String(nation.year), "Key removal year", nation.color)
                    }
                    .padding(.bottom, 14)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("DISPLACED TO")
                            .font(fLabel(9)).tracking(3).foregroundStyle(T.faint)
                        Text(nation.displaced).font(fBody(15)).foregroundStyle(T.muted)
                        Text("from \(nation.presentDay)")
                            .font(fBody(12, italic: true)).foregroundStyle(T.faint)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(T.rust.opacity(0.07))
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(T.rust.opacity(0.18), lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                    Spacer().frame(height: 100)
                }
                .padding(.horizontal, 28)
                .padding(.top, 56)
            }
        }
        .navigationBarHidden(true)
    }

    @ViewBuilder
    func sectionBlock(_ title: String, _ body: String, _ color: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title.uppercased())
                .font(fLabel(9)).tracking(3).foregroundStyle(color.opacity(0.7))
            Text(body).font(fBody(15)).foregroundStyle(T.muted).lineSpacing(6)
        }
        .padding(.bottom, 20)
        Rectangle().fill(nation.color.opacity(0.15)).frame(height: 1).padding(.bottom, 24)
    }

    @ViewBuilder
    func statTile(_ value: String, _ label: String, _ color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value).font(fDisplay(26)).foregroundStyle(T.gold)
            Text(label.uppercased())
                .font(fLabel(9)).tracking(1).foregroundStyle(T.faint)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity).padding(16)
        .background(color.opacity(0.05))
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(color.opacity(0.18), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
