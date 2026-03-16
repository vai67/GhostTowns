import SwiftUI

struct Eyebrow: View {
    let text: String
    var body: some View {
        Text(text.uppercased())
            .font(fLabel(11)).tracking(5)
            .foregroundStyle(T.gold.opacity(0.78))
    }
}

struct EarthBtn: View {
    let label: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(label.uppercased())
                .font(fLabel(13)).tracking(3)
                .foregroundStyle(T.cream)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(LinearGradient(colors: [T.rust, T.darkRust], startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(RoundedRectangle(cornerRadius: 3).stroke(T.gold.opacity(0.35), lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 3))
                .shadow(color: T.rust.opacity(0.4), radius: 14, y: 8)
        }
    }
}

struct GhostBtn: View {
    let label: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(fLabel(13)).tracking(2)
                .foregroundStyle(T.gold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 11)
                .background(T.gold.opacity(0.07))
                .overlay(RoundedRectangle(cornerRadius: 3).stroke(T.gold.opacity(0.2), lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 3))
        }
    }
}

struct BackBtn: View {
    let label: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: "arrow.left").font(.system(size: 12))
                Text(label).font(fBody(14))
            }
            .foregroundStyle(T.gold.opacity(0.6))
        }
    }
}

struct HR: View {
    var body: some View {
        Rectangle()
            .fill(LinearGradient(colors: [.clear, T.rust.opacity(0.4), .clear], startPoint: .leading, endPoint: .trailing))
            .frame(height: 1)
    }
}

struct RegionBadge: View {
    let text: String
    let color: Color
    var body: some View {
        Text(text.uppercased())
            .font(fLabel(9)).tracking(2)
            .foregroundStyle(T.gold)
            .padding(.horizontal, 10).padding(.vertical, 3)
            .overlay(RoundedRectangle(cornerRadius: 2).stroke(color.opacity(0.4), lineWidth: 1))
    }
}
