import SwiftUI

struct DataView: View {
    @Binding var path: NavigationPath
    @State private var showSources = false

    var body: some View {
        ZStack {
            T.bg.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    BackBtn(label: "Home") { path.removeLast() }
                        .padding(.bottom, 24)

                    Eyebrow(text: "The Land in Numbers").padding(.bottom, 10)

                    Text("What was taken.")
                        .font(fDisplay(36)).foregroundStyle(T.cream).padding(.bottom, 10)

                    Text("The United States occupies 2.4 billion acres. Of those, only 56 million remain as tribal land. That is less than 4 percent.")
                        .font(fBody(16)).foregroundStyle(T.muted).lineSpacing(5).padding(.bottom, 40)

                    LandLossViz()

                    // 574 + 9.7M
                    HStack(alignment: .top, spacing: 32) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("574").font(fDisplay(38)).foregroundStyle(T.gold)
                            Text("FEDERALLY RECOGNIZED")
                                .font(fLabel(11)).tracking(2).foregroundStyle(T.faint)
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text("9.7M").font(fDisplay(38)).foregroundStyle(T.sage)
                            Text("NATIVE AMERICANS TODAY")
                                .font(fLabel(11)).tracking(2).foregroundStyle(T.faint)
                        }
                    }
                    .padding(.bottom, 20)

                    Text("Hundreds more tribes are still seeking federal recognition. Without it, they have no legal standing to reclaim land or protect their culture.")
                        .font(fBody(15)).foregroundStyle(T.faint).lineSpacing(5)
                        .padding(.bottom, 32)

                    HR().padding(.bottom, 32)

                    // 150+ languages
                    HStack(alignment: .lastTextBaseline, spacing: 10) {
                        Text("150+").font(fDisplay(44)).foregroundStyle(T.slate)
                        Text("languages endangered").font(fBody(15, italic:true)).foregroundStyle(T.faint)
                    }
                    .padding(.bottom, 8)

                    Text("Of roughly 300 Indigenous languages spoken before contact, more than half are now critically endangered. When a language dies, it takes with it a way of seeing the world that cannot be reconstructed.")
                        .font(fBody(16)).foregroundStyle(T.muted).lineSpacing(5).padding(.bottom, 32)

                    HR().padding(.bottom, 32)

                    // $2B block
                    VStack(alignment: .leading, spacing: 0) {
                        Text("THE UNCLAIMED $2 BILLION")
                            .font(fLabel(11)).tracking(4).foregroundStyle(T.gold).padding(.bottom, 14)
                        Text("$2,000,000,000")
                            .font(fDisplay(38)).foregroundStyle(Color(hex:"#A8882A")!).padding(.bottom, 14)
                        Text("In 1980 the Supreme Court ruled the Black Hills had been illegally seized from the Lakota Sioux and awarded $106 million in compensation.")
                            .font(fBody(16)).foregroundStyle(T.muted).lineSpacing(5).padding(.bottom, 12)
                        Text("The Lakota refused it. That money has grown to more than two billion dollars and sits unclaimed. Their position has never changed. They want the land, not the money.")
                            .font(fBody(16, italic:true)).foregroundStyle(T.cream.opacity(0.75)).lineSpacing(5)
                    }
                    .padding(20)
                    .background(Color(hex:"#5C4A1E")!.opacity(0.1))
                    .overlay(RoundedRectangle(cornerRadius:6).stroke(Color(hex:"#5C4A1E")!.opacity(0.28), lineWidth:1))
                    .clipShape(RoundedRectangle(cornerRadius:6))
                    .padding(.bottom, 28)

                    // sources button
                    Button { showSources = true } label: {
                        Text("Sources & Methodology")
                            .font(fLabel(13)).tracking(3)
                            .foregroundStyle(T.muted.opacity(0.55))
                            .frame(maxWidth:.infinity).padding(.vertical, 13)
                            .background(T.rust.opacity(0.08))
                            .overlay(RoundedRectangle(cornerRadius:3).stroke(T.rust.opacity(0.22), lineWidth:1))
                            .clipShape(RoundedRectangle(cornerRadius:3))
                    }
                    .padding(.bottom, 20)

                    HR().padding(.bottom, 14)

                    Text("Bureau of Indian Affairs · U.S. Census 2020 · Native Land Digital · National Archives · Smithsonian NMAI")
                        .font(fBody(13)).foregroundStyle(T.muted.opacity(0.55)).lineSpacing(4)

                    Spacer().frame(height: 100)
                }
                .padding(.horizontal, 28).padding(.top, 56)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showSources) { SourcesSheet() }
    }
}

// ── LAND LOSS VIZ ────────────────────────────────────────────────
struct LandLossViz: View {
    @State private var phase: Phase = .idle
    @State private var dissolvedCount = 0
    @State private var activeEvent: BlockEvent? = nil
    @State private var showReflection = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    enum Phase { case idle, dissolving, done }
    var isIdle: Bool { phase == .idle }
    var isDone:  Bool { phase == .done }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // tappable 96%
            HStack(alignment: .lastTextBaseline, spacing: 14) {
                Text("96%")
                    .font(fDisplay(72)).foregroundStyle(T.rust)
                VStack(alignment: .leading, spacing: 5) {
                    Text("of all tribal land")
                        .font(fBody(15, italic:true)).foregroundStyle(T.faint)
                    Text(isIdle ? "tap to witness the change" : isDone ? "tap to reset" : "")
                        .font(fLabel(11)).tracking(2).foregroundStyle(T.gold.opacity(0.55))
                }
            }
            .padding(.horizontal, 12).padding(.vertical, 6)
            .background(isIdle ? T.gold.opacity(0.04) : T.rust.opacity(0.07))
            .overlay(RoundedRectangle(cornerRadius:4).stroke(
                isIdle ? T.gold.opacity(0.28) : T.rust.opacity(0.35), lineWidth:1))
            .clipShape(RoundedRectangle(cornerRadius:4))
            .onTapGesture { if isIdle { start() } else if isDone { reset() } }
            .padding(.bottom, 10)

            // event label fixed height so grid doesn't jump
            ZStack(alignment: .topLeading) {
                Color.clear.frame(height: 56)
                if let ev = activeEvent {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(String(ev.year)).font(fLabel(11)).tracking(3).foregroundStyle(T.gold)
                        Text(ev.label).font(fBody(15)).foregroundStyle(T.muted).lineSpacing(3)
                    }
                    .transition(.opacity)
                } else if isDone {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("1953").font(fLabel(11)).tracking(3).foregroundStyle(T.rust.opacity(0.6))
                        Text("Termination Policy, the last systematic removal")
                            .font(fBody(15)).foregroundStyle(T.faint)
                    }
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: activeEvent?.year)
            .padding(.bottom, 18)

            // 5×3 block grid
            VStack(spacing: 5) {
                ForEach(0..<3, id:\.self) { row in
                    HStack(spacing: 5) {
                        ForEach(0..<5, id:\.self) { col in
                            let idx = row * 5 + col
                            BlockCell(idx: idx, dissolvedCount: dissolvedCount)
                        }
                    }
                }
            }
            .padding(.bottom, 14)

            HStack {
                Text("EACH BLOCK = 100M ACRES")
                Spacer()
                Text("15 BLOCKS = 1.5B ORIGINAL")
            }
            .font(fLabel(8)).tracking(1).foregroundStyle(T.vfaint).padding(.bottom, 20)

            if showReflection {
                HStack(alignment: .top, spacing: 0) {
                    Rectangle().fill(T.rust.opacity(0.4)).frame(width:2)
                        .clipShape(RoundedRectangle(cornerRadius:2))
                    Text("Fourteen of fifteen blocks. Gone in under three centuries. What remains fits inside a single square on this grid.")
                        .font(fDisplay(15, italic:true)).foregroundStyle(T.muted).lineSpacing(6)
                        .padding(.leading, 14)
                }
                .transition(.opacity)
                .animation(.easeIn(duration:0.8), value:showReflection)
            }
        }
        .padding(.bottom, 48)
    }

    func start() {
        guard isIdle else { return }
        phase = .dissolving; dissolvedCount = 0; activeEvent = nil; showReflection = false

        func next(_ count: Int) {
            guard count <= 14 else {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    withAnimation { phase = .done; activeEvent = nil }
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.8) {
                        withAnimation { showReflection = true }
                    }
                    UIImpactFeedbackGenerator(style:.soft).impactOccurred()
                }
                return
            }
            withAnimation(.easeOut(duration:0.5)) {
                dissolvedCount = count
                if let ev = BlockEvent.all[count] { activeEvent = ev }
            }
            let delay = count < 5 ? 0.22 : count < 10 ? 0.28 : 0.36
            DispatchQueue.main.asyncAfter(deadline: .now()+delay) { next(count+1) }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.6) { next(1) }
    }

    func reset() {
        withAnimation { phase = .idle; dissolvedCount = 0; activeEvent = nil; showReflection = false }
    }
}

struct BlockCell: View {
    let idx: Int
    let dissolvedCount: Int

    var isGone:     Bool { idx > 0 && idx <= dissolvedCount }
    var isSurvivor: Bool { idx == 0 }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius:2)
                .fill(isSurvivor
                    ? LinearGradient(colors:[T.rust,T.darkRust], startPoint:.topLeading, endPoint:.bottomTrailing)
                    : LinearGradient(colors:[isGone ? Color(white:0.06) : T.rust.opacity(0.2),
                                             isGone ? Color(white:0.05) : T.rust.opacity(0.15)],
                                     startPoint:.top, endPoint:.bottom))
                .overlay(RoundedRectangle(cornerRadius:2).stroke(
                    isSurvivor ? T.gold.opacity(0.5) : isGone ? T.rust.opacity(0.1) : T.rust.opacity(0.28),
                    lineWidth:1))

            if isGone {
                Canvas { ctx, size in
                    var p1 = Path(); p1.move(to:.zero); p1.addLine(to:CGPoint(x:size.width,y:size.height))
                    var p2 = Path(); p2.move(to:CGPoint(x:size.width,y:0)); p2.addLine(to:CGPoint(x:0,y:size.height))
                    ctx.stroke(p1, with:.color(T.rust.opacity(0.18)), lineWidth:0.9)
                    ctx.stroke(p2, with:.color(T.rust.opacity(0.18)), lineWidth:0.9)
                }
            }
            if isSurvivor {
                Text("56M ac").font(fLabel(8)).tracking(1).foregroundStyle(T.cream.opacity(0.45))
            }
        }
        .frame(height:50)
        .opacity(isGone ? 0.4 : 1)
        .scaleEffect(isGone ? 0.92 : 1)
        .animation(.easeOut(duration:0.7), value:isGone)
    }
}

struct SourcesSheet: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color(hex:"#131110")!.ignoresSafeArea()
            ScrollView {
                VStack(alignment:.leading, spacing:0) {
                    RoundedRectangle(cornerRadius:2).fill(Color.white.opacity(0.08))
                        .frame(width:36,height:3).frame(maxWidth:.infinity).padding(.bottom,24)

                    Text("Sources & Methodology")
                        .font(fLabel(11)).tracking(5).textCase(.uppercase)
                        .foregroundStyle(T.cream.opacity(0.55)).padding(.bottom,14)

                    Text("Each statistic is drawn from federal records, academic sources and Indigenous-led research organizations. Where estimates vary, the most conservative figure is used.")
                        .font(fBody(15)).foregroundStyle(T.cream.opacity(0.55)).lineSpacing(5).padding(.bottom,28)

                    ForEach(Source.all) { s in
                        VStack(alignment:.leading, spacing:5) {
                            Text(s.stat).font(fBody(15)).foregroundStyle(T.cream.opacity(0.75))
                            Text(s.source).font(fBody(15,italic:true)).foregroundStyle(T.cream.opacity(0.35)).lineSpacing(3)
                        }
                        .padding(.bottom,20)
                        if s.id < Source.all.count-1 {
                            Rectangle().fill(Color.white.opacity(0.05)).frame(height:1).padding(.bottom,20)
                        }
                    }

                    Button("Close") { dismiss() }
                        .font(fLabel(13)).tracking(3)
                        .foregroundStyle(T.muted.opacity(0.55))
                        .frame(maxWidth:.infinity).padding(.vertical,13)
                        .background(T.rust.opacity(0.1))
                        .overlay(RoundedRectangle(cornerRadius:3).stroke(T.rust.opacity(0.2),lineWidth:1))
                        .clipShape(RoundedRectangle(cornerRadius:3))
                        .padding(.top,8)
                }
                .padding(28)
            }
        }
    }
}
