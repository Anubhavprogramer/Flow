import SwiftUI
import Playgrounds
import SwiftData

@main struct MyApp: App {
    
    @StateObject var appState = AppStats()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appState)
        }
        .modelContainer(for: [
            Project.self,
            CanvasScreen.self
        ])
    }
}
