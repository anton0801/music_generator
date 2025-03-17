import SwiftUI

struct ContentView: View {
    
    @StateObject var trackViewModel = TrackViewModel()
    @StateObject var musicPlayerViewModel = MusicPlayerViewModel()
    
    var body: some View {
        ZStack {
            TabView {
                HomeView()
                    .environmentObject(trackViewModel)
                    .environmentObject(musicPlayerViewModel)
                    .tabItem {
                        Image("songs_all")
                    }
                    .tag(0)
                CreateTrackView()
                    .environmentObject(trackViewModel)
                    .environmentObject(musicPlayerViewModel)
                    .tabItem {
                        Image("create_song")
                    }
                    .tag(1)
                SearchSongsView()
                    .environmentObject(trackViewModel)
                    .environmentObject(musicPlayerViewModel)
                    .tabItem {
                        Image("search")
                    }
                    .tag(2)
            }
            
            if trackViewModel.musicProGenFull {
                GeneratingMusicNewStyleRequestView()
            }
        }
    }
}

#Preview {
    ContentView()
}
