import SwiftUI

@main
struct Music_GeneratorApp: App {
    
    @UIApplicationDelegateAdaptor(MusicProGenDelegate.self) var musicProGenDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
