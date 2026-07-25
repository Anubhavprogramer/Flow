import SwiftUI
import Playgrounds

@main struct MyApp: App {
    
    @StateObject var appState = AppStats()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appState)
        }
    }
}
