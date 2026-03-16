import SwiftUI
import CoreLocation
import Combine
import UIKit

struct ScannerView: View {
    @Binding var path: NavigationPath
    @StateObject private var vm = ScannerVM()
    @State private var spinning = false

    var body: some View {
        ZStack {
            Color(hex: "#080502")!.ignoresSafeArea()

            // map in upper portion
            GeometryReader { geo in
                MapBg()
                    .frame(width: geo.size.width * 1.2, height: geo.size.height * 0.72)
                    .offset(x: -geo.size.width * 0.1, y: geo.size.height * 0.18)
            }

            // spinning green radar while scanning
            if vm.phase == .locating || vm.phase == .querying {
                GeometryReader { geo in
                    ZStack {
                        Circle()
                            .fill(RadialGradient(
                                colors: [
                                    Color(red: 0.16, green: 0.35, blue: 0.16).opacity(0.35),
                                    Color(red: 0.10, green: 0.26, blue: 0.10).opacity(0.15),
                                    .clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 150
                            ))
                            .frame(width: 300, height: 300)
                            .blur(radius: 30)

                        Circle()
                            .trim(from: 0, to: 0.75)
                            .stroke(Color(red: 0.24, green: 0.55, blue: 0.20).opacity(0.6), lineWidth: 1.5)
                            .frame(width: 200, height: 200)
                            .rotationEffect(.degrees(spinning ? 360 : 0))
                            .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: spinning)

                        Circle()
                            .trim(from: 0, to: 0.6)
                            .stroke(Color(red: 0.31, green: 0.63, blue: 0.24).opacity(0.4), lineWidth: 1)
                            .frame(width: 130, height: 130)
                            .rotationEffect(.degrees(spinning ? -360 : 0))
                            .animation(.linear(duration: 1.4).repeatForever(autoreverses: false), value: spinning)

                        Circle()
                            .fill(Color(red: 0.39, green: 0.71, blue: 0.27).opacity(0.8))
                            .frame(width: 8, height: 8)
                            .shadow(color: Color(red: 0.31, green: 0.71, blue: 0.20).opacity(0.6), radius: 6)
                    }
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.49)
                }
                .onAppear { spinning = true }
            }

            // corner brackets
            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height
                Group {
                    bracketView(top: true, left: true).position(x: 42, y: 104)
                    bracketView(top: true, left: false).position(x: w - 42, y: 104)
                    bracketView(top: false, left: true).position(x: 42, y: h - 86)
                    bracketView(top: false, left: false).position(x: w - 42, y: h - 86)
                }
            }

            // top bar
            VStack {
                HStack {
                    BackBtn(label: "Back") { path.removeLast() }
                    Spacer()
                    Eyebrow(text: "Land Scanner")
                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        if let c = vm.coordinate {
                            Text(String(format: "%.4f° N", c.latitude))
                            Text(String(format: "%.4f° W", abs(c.longitude)))
                        } else {
                            Text("Awaiting").opacity(0.6)
                            Text("GPS").opacity(0.6)
                        }
                    }
                    .font(fLabel(9))
                    .tracking(1)
                    .foregroundStyle(T.gold.opacity(0.6))
                }
                .padding(.horizontal, 24)
                .padding(.top, 56)
                Spacer()
            }

            // center idle state + instructions
            VStack {
                Spacer()

                if vm.phase == .idle {
                    Text("Point at any ground in America to identify\nwhose land you are standing on.")
                        .font(fBody(15))
                        .foregroundStyle(T.muted)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 40)
                } else if vm.phase == .locating {
                    Text("Getting your location...")
                        .font(fLabel(11))
                        .tracking(4)
                        .textCase(.uppercase)
                        .foregroundStyle(T.cream.opacity(0.45))
                } else if vm.phase == .querying {
                    Text("Tracing this land back...")
                        .font(fLabel(11))
                        .tracking(4)
                        .textCase(.uppercase)
                        .foregroundStyle(T.cream.opacity(0.45))
                }

                Spacer().frame(height: 100)
            }

            // scan button near bottom
            if vm.phase == .idle {
                VStack {
                    Spacer()
                    EarthBtn(label: "Scan this ground") { vm.startScan(path: path) }
                        .padding(.horizontal, 28)
                        .padding(.bottom, 160)
                }
            }

            // error
            if vm.phase == .error {
                VStack {
                    Spacer()
                    VStack(spacing: 16) {
                        Text(vm.errorMessage ?? "Something went wrong.")
                            .font(fBody(15))
                            .foregroundStyle(T.muted)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)

                        EarthBtn(label: "Try again") { vm.reset() }
                            .padding(.horizontal, 28)
                    }
                    Spacer().frame(height: 120)
                }
            }

            // found nation slides up
            if vm.phase == .found, let nation = vm.foundNation {
                VStack {
                    Spacer()
                    foundCard(nation: nation)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .ignoresSafeArea(edges: .bottom)
            }

            if vm.phase == .unknown, let name = vm.unknownNationName {
                VStack {
                    Spacer()
                    unknownCard(name: name)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .navigationBarHidden(true)
        .animation(.easeOut(duration: 0.45), value: vm.phase)
    }

    func bracketView(top: Bool, left: Bool) -> some View {
        ZStack {
            Rectangle().fill(T.gold.opacity(0.5)).frame(width: 28, height: 1.5).offset(x: left ? 14 : -14)
            Rectangle().fill(T.gold.opacity(0.5)).frame(width: 1.5, height: 28).offset(y: top ? 14 : -14)
        }
    }

    func foundCard(nation: Nation) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.white.opacity(0.1))
                .frame(width: 34, height: 3)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)

            Eyebrow(text: "Ancestral Land Identified")
                .padding(.bottom, 10)

            if vm.isOfflineDemo {
                Text("OFFLINE DEMO")
                    .font(fLabel(9))
                    .tracking(3)
                    .foregroundStyle(T.faint)
                    .padding(.bottom, 10)
            }

            Text(nation.name)
                .font(fDisplay(38))
                .foregroundStyle(T.cream)

            Text(nation.also)
                .font(fBody(13, italic: true))
                .foregroundStyle(T.faint)
                .padding(.bottom, 16)

            HR().padding(.bottom, 14)

            Text(String(nation.land.prefix(120)) + "...")
                .font(fBody(15))
                .foregroundStyle(T.muted)
                .lineSpacing(5)
                .padding(.bottom, 20)

            EarthBtn(label: "Read their full story") {
                path.append(Route.nation(nation))
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 40)
        .background(Color(hex: "#090502")!.opacity(0.97))
        .overlay(HR().frame(maxHeight: .infinity, alignment: .top))
    }

    func unknownCard(name: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.white.opacity(0.1))
                .frame(width: 34, height: 3)
                .frame(maxWidth: .infinity)

            Eyebrow(text: "Ancestral Territory Identified")

            Text(name)
                .font(fDisplay(32))
                .foregroundStyle(T.cream)

            Text("This land belongs to a nation not yet in our detailed records.")
                .font(fBody(14))
                .foregroundStyle(T.faint)
                .lineSpacing(4)
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 40)
        .background(Color(hex: "#090502")!.opacity(0.97))
    }
}

// MARK: - GPS + API logic
class ScannerVM: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var phase: Phase = .idle
    @Published var foundNation: Nation?
    @Published var unknownNationName: String?
    @Published var coordinate: CLLocationCoordinate2D?
    @Published var errorMessage: String?
    @Published var isOfflineDemo: Bool = false

    private let mgr = CLLocationManager()
    private var locationCompletion: ((Result<CLLocationCoordinate2D, Error>) -> Void)?
    private var timeoutWorkItem: DispatchWorkItem?

    enum Phase { case idle, locating, querying, found, unknown, error }
    enum Err: Error { case denied, timeout }

    override init() {
        super.init()
        mgr.delegate = self
        mgr.desiredAccuracy = kCLLocationAccuracyBest
    }

    @MainActor
    func startScan(path: NavigationPath) {
        phase = .locating
        foundNation = nil
        unknownNationName = nil
        errorMessage = nil
        isOfflineDemo = false

        Task {
            do {
                let c = try await locate()
                await MainActor.run {
                    self.coordinate = c
                    self.phase = .querying
                }

                do {
                    let slugs = try await queryAPI(lat: c.latitude, lng: c.longitude)

                    if slugs.isEmpty {
                        await MainActor.run {
                            self.errorMessage = "No territory data found for this location."
                            self.phase = .error
                        }
                        return
                    }

                    for s in slugs {
                        if let n = Nation.match(slug: s) {
                            await MainActor.run {
                                self.foundNation = n
                                self.phase = .found
                                self.isOfflineDemo = false
                            }
                            await MainActor.run { self.haptic() }
                            return
                        }
                    }

                    let unknown = slugs.first?
                        .replacingOccurrences(of: "-", with: " ")
                        .capitalized

                    await MainActor.run {
                        self.unknownNationName = unknown
                        self.phase = .unknown
                    }

                } catch {
                    await MainActor.run {
                        self.errorMessage = "No internet connection. Showing an offline demo."
                        self.foundNation = Nation.demo
                        self.isOfflineDemo = true
                        self.phase = .found
                        self.haptic()
                    }
                }

            } catch {
                await MainActor.run {
                    self.errorMessage = "Could not get your location. Check permissions and try again."
                    self.phase = .error
                }
            }
        }
    }

    @MainActor
    func reset() {
        phase = .idle
        foundNation = nil
        unknownNationName = nil
        coordinate = nil
        errorMessage = nil
        isOfflineDemo = false
    }

    @MainActor
    private func haptic() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }

    private func locate() async throws -> CLLocationCoordinate2D {
        try await withCheckedThrowingContinuation { cont in
            timeoutWorkItem?.cancel()
            timeoutWorkItem = nil
            locationCompletion = nil

            let status = mgr.authorizationStatus

            if status == .denied || status == .restricted {
                cont.resume(throwing: Err.denied)
                return
            }

            locationCompletion = { result in
                Task { @MainActor in
                    switch result {
                    case .success(let c):
                        cont.resume(returning: c)
                    case .failure(let e):
                        cont.resume(throwing: e)
                    }
                }
            }

            let work = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                if let completion = self.locationCompletion {
                    self.locationCompletion = nil
                    completion(.failure(Err.timeout))
                }
            }
            timeoutWorkItem = work
            DispatchQueue.main.asyncAfter(deadline: .now() + 6, execute: work)

            if status == .notDetermined {
                mgr.requestWhenInUseAuthorization()
            } else {
                mgr.requestLocation()
            }
        }
    }

    private func queryAPI(lat: Double, lng: Double) async throws -> [String] {
        guard let url = URL(string: "https://native-land.ca/api/index.php?maps=territories&position=\(lat),\(lng)") else {
            throw APIErr.badURL
        }

        var req = URLRequest(url: url)
        req.timeoutInterval = 6

        let (data, response) = try await URLSession.shared.data(for: req)

        if let http = response as? HTTPURLResponse {
            if http.statusCode < 200 || http.statusCode > 299 {
                throw APIErr.http(http.statusCode)
            }
        }

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            throw APIErr.badJSON
        }

        return json.compactMap { item in
            let props = item["properties"] as? [String: Any]
            return props?["slug"] as? String
        }
    }

    enum APIErr: Error { case badURL, http(Int), badJSON }

    // MARK: - CLLocationManagerDelegate (must be nonisolated-safe)

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.requestLocation()
            return
        }
        if status == .denied || status == .restricted {
            if let completion = locationCompletion {
                locationCompletion = nil
                timeoutWorkItem?.cancel()
                timeoutWorkItem = nil
                completion(.failure(Err.denied))
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let c = locations.first?.coordinate else { return }
        if let completion = locationCompletion {
            locationCompletion = nil
            timeoutWorkItem?.cancel()
            timeoutWorkItem = nil
            completion(.success(c))
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let completion = locationCompletion {
            locationCompletion = nil
            timeoutWorkItem?.cancel()
            timeoutWorkItem = nil
            completion(.failure(error))
        }
    }
}
