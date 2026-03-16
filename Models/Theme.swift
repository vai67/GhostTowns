import SwiftUI

enum T {
    static let bg       = Color(hex: "#0F0A06")!
    static let surface  = Color(hex: "#181008")!
    static let cream    = Color(hex: "#F0E8DC")!
    static let muted    = Color(hex: "#F0E8DC")!.opacity(0.80)
    static let faint    = Color(hex: "#F0E8DC")!.opacity(0.55)
    static let vfaint   = Color(hex: "#F0E8DC")!.opacity(0.55)
    static let gold     = Color(hex: "#C4874A")!
    static let rust     = Color(hex: "#8B4513")!
    static let darkRust = Color(hex: "#5C2C08")!
    static let sage     = Color(hex: "#7A9A7A")!
    static let slate    = Color(hex: "#4A6B7A")!
}

// font helpers matching JSX F.display / F.body / F.label
func fDisplay(_ size: CGFloat, italic: Bool = false) -> Font {
    italic ? .custom("Georgia-Italic", size: size) : .custom("Georgia", size: size)
}
func fBody(_ size: CGFloat, italic: Bool = false) -> Font {
    italic ? .custom("Georgia-Italic", size: size) : .custom("Georgia", size: size)
}
func fLabel(_ size: CGFloat) -> Font {
    .system(size: size, weight: .light, design: .default)
}

extension Color {
    init?(hex: String) {
        let h = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        guard h.count == 6, let val = UInt64(h, radix: 16) else { return nil }
        self.init(
            red:   Double((val >> 16) & 0xFF) / 255,
            green: Double((val >> 8)  & 0xFF) / 255,
            blue:  Double( val        & 0xFF) / 255
        )
    }
}
