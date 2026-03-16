import SwiftUI

struct MapBg: View {
    var body: some View {
        GeometryReader { geo in
            Canvas { ctx, size in
                let sx = size.width / 390
                let sy = size.height / 480

                // warm base
                ctx.fill(Path(CGRect(origin: .zero, size: size)),
                         with: .color(Color(hex: "#2A1608")!.opacity(0.65)))

                // grid lines
                let gc = GraphicsContext.Shading.color(Color(hex: "#C4874A")!.opacity(0.2))
                for y in [75.0,130,185,240,295,350,405,460] {
                    var p = Path(); p.move(to: CGPoint(x:0, y:y*sy)); p.addLine(to: CGPoint(x:size.width, y:y*sy))
                    ctx.stroke(p, with: gc, lineWidth: 0.35)
                }
                for x in [48.0,104,160,216,272,328,384] {
                    var p = Path(); p.move(to: CGPoint(x:x*sx, y:0)); p.addLine(to: CGPoint(x:x*sx, y:size.height))
                    ctx.stroke(p, with: gc, lineWidth: 0.35)
                }

                // US outline
                let pts: [(Double,Double)] = [
                    (52,98),(78,80),(118,72),(160,67),(200,65),(244,67),(288,72),(322,82),(346,97),
                    (360,114),(354,135),(365,156),(360,176),(346,193),(332,207),(316,222),(300,234),
                    (280,245),(258,258),(238,270),(218,282),(200,294),(182,302),(165,306),(148,300),
                    (132,288),(116,272),(102,255),(88,237),(72,218),(58,198),(46,175),(44,152),(50,126)
                ]
                var us = Path()
                us.move(to: CGPoint(x:pts[0].0*sx, y:pts[0].1*sy))
                for pt in pts.dropFirst() { us.addLine(to: CGPoint(x:pt.0*sx, y:pt.1*sy)) }
                us.closeSubpath()
                ctx.fill(us, with: .color(Color(hex:"#3D1E08")!.opacity(0.45)))
                ctx.stroke(us, with: .color(Color(hex:"#C4874A")!.opacity(0.55)),
                           style: StrokeStyle(lineWidth:1.4, dash:[5,3]))

                // territory dividers
                let dc = GraphicsContext.Shading.color(Color(hex:"#C4874A")!.opacity(0.28))
                var d1 = Path()
                d1.move(to: CGPoint(x:198*sx, y:68*sy))
                d1.addCurve(to: CGPoint(x:190*sx, y:306*sy),
                    control1: CGPoint(x:194*sx, y:155*sy),
                    control2: CGPoint(x:194*sx, y:234*sy))
                ctx.stroke(d1, with: dc, style: StrokeStyle(lineWidth:1, dash:[7,4]))

                var d2 = Path()
                d2.move(to: CGPoint(x:130*sx, y:76*sy))
                d2.addLine(to: CGPoint(x:120*sx, y:190*sy))
                ctx.stroke(d2, with: dc, style: StrokeStyle(lineWidth:0.7, dash:[4,5]))

                // compass rose
                let cx = 352*sx, cy = 94*sy
                let cc = GraphicsContext.Shading.color(Color(hex:"#C4874A")!.opacity(0.52))
                var ring = Path()
                ring.addEllipse(in: CGRect(x:cx-16*sx, y:cy-16*sy, width:32*sx, height:32*sy))
                ctx.stroke(ring, with: cc, lineWidth: 0.9)
                var vl = Path(); vl.move(to: CGPoint(x:cx,y:cy-19*sy)); vl.addLine(to: CGPoint(x:cx,y:cy+19*sy))
                var hl = Path(); hl.move(to: CGPoint(x:cx-19*sx,y:cy)); hl.addLine(to: CGPoint(x:cx+19*sx,y:cy))
                ctx.stroke(vl, with: cc, lineWidth: 0.9)
                ctx.stroke(hl, with: cc, lineWidth: 0.9)
            }
            .frame(width: geo.size.width, height: geo.size.height)

            // territory name labels
            let sx = geo.size.width / 390
            let sy = geo.size.height / 480
            let labels: [(String,Double,Double,Double)] = [
                ("LENAPEHOKING",55,98,-4), ("HAUDENOSAUNEE",232,140,-2),
                ("CHEROKEE",242,226,2), ("LAKOTA",95,184,-3),
                ("DINE",60,252,-1), ("MUSCOGEE",228,276,3),
            ]
            ForEach(labels, id: \.0) { label, x, y, rot in
                Text(label)
                    .font(.custom("Georgia", size: 8.5)).tracking(2.5)
                    .foregroundStyle(Color(hex:"#E8C88A")!.opacity(0.85))
                    .rotationEffect(.degrees(rot))
                    .position(x: x*sx, y: y*sy)
            }

            // nation dots
            let dots: [(Double,Double)] = [(82,128),(264,220),(112,182),(254,270),(256,134),(75,248)]
            ForEach(Array(dots.enumerated()), id:\.offset) { _, dot in
                ZStack {
                    Circle().stroke(Color(hex:"#C4874A")!.opacity(0.5), lineWidth:1).frame(width:9*sx,height:9*sx)
                    Circle().fill(Color(hex:"#C4874A")!.opacity(0.65)).frame(width:4*sx,height:4*sx)
                }
                .position(x:dot.0*sx, y:dot.1*sy)
            }

            // vignette
            RadialGradient(colors:[.clear, Color(hex:"#0F0A06")!.opacity(0.94)],
                           center:.init(x:0.5,y:0.38), startRadius:0, endRadius:280)
            LinearGradient(colors:[.clear, Color(hex:"#0F0A06")!],
                           startPoint:.init(x:0.5,y:0.4), endPoint:.bottom)
            LinearGradient(colors:[Color(hex:"#0F0A06")!.opacity(0.7), .clear],
                           startPoint:.top, endPoint:.init(x:0.5,y:0.35))
                .frame(height:200).frame(maxHeight:.infinity, alignment:.top)
        }
        .ignoresSafeArea()
    }
}
