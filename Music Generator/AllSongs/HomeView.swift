import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    
    @EnvironmentObject var musicPlayerVm: MusicPlayerViewModel
    @EnvironmentObject var tracksVM: TrackViewModel
    
    @State private var fullPlayerView = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Saved songs")
                    .font(.custom("NunitoSans-12ptExtraLight_Bold", size: 24))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.init(red: 213/255, green: 34/255, blue: 53/255))
                
                ScrollView {
                    ForEach(tracksVM.tracks, id: \.id) { track in
                        Button {
                            withAnimation {
                                musicPlayerVm.currentTrack = track
                                musicPlayerVm.playTrack(musicPlayerVm.currentTrack!)
                            }
                        } label: {
                            HStack {
                                WebImage(url: URL(string: track.imageUrl))
                                    .resizable()
                                    .frame(width: 52, height: 52)
                                
                                VStack(alignment: .leading) {
                                    Text(track.title)
                                        .font(.custom("NunitoSans-Regular", size: 20))
                                        .foregroundColor(.black)
                                    Text(track.author)
                                        .font(.custom("NunitoSans-Regular", size: 16))
                                        .foregroundColor(.black)
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                if let _ = musicPlayerVm.currentTrack {
                    MiniPlayer()
                        .environmentObject(musicPlayerVm)
                        .onTapGesture {
                            fullPlayerView = true
                        }
                }
            }
            .fullScreenCover(isPresented: $fullPlayerView) {
                DetailsMusicPlayerView()
                    .environmentObject(tracksVM)
                    .environmentObject(musicPlayerVm)
            }
        }
    }
    
}

#Preview {
    HomeView()
        .environmentObject(MusicPlayerViewModel())
        .environmentObject(TrackViewModel())
}
