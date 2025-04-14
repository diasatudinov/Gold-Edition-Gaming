import SwiftUI

@main
struct Gold_Edition_GamingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            RootViewDC()
                .preferredColorScheme(.light)
        }
    }
}
