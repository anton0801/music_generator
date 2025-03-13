import SwiftUI
import SDWebImageSwiftUI

struct SearchSongsView: View {
    
    @EnvironmentObject var musicPlayerVm: MusicPlayerViewModel
    @EnvironmentObject var tracksVM: TrackViewModel
    
    @State var searchQuery: String = ""
    @State var tracksForSee: [Track] = []
    
    var body: some View {
        VStack {
            Text("Search")
                .font(.custom("NunitoSans-12ptExtraLight_Bold", size: 24))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.init(red: 213/255, green: 34/255, blue: 53/255))
            
            ZStack(alignment: .leading) {
                TextField("", text: $searchQuery)
                    .font(.custom("NunitoSans-12ptExtraLight_Regular", size: 18))
                    .padding()
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.init(red: 213/255, green: 34/255, blue: 53/255))
                    )
                    .padding(.horizontal)
                
                if searchQuery.isEmpty {
                    Text("Search song....")
                        .font(.custom("NunitoSans-12ptExtraLight_Regular", size: 18))
                        .foregroundColor(.white)
                        .padding(.leading, 32)
                }
            }
            
            ScrollView {
                ForEach(tracksForSee, id: \.id) { track in
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
            }
        }
        .onAppear {
            tracksForSee = tracksVM.tracks
        }
        .onChange(of: searchQuery) { newValue in
            if searchQuery.isEmpty {
                withAnimation {
                    tracksForSee = tracksVM.tracks
                }
            } else {
                withAnimation {
                    tracksForSee = tracksVM.tracks.filter { $0.title.contains(searchQuery) || $0.author.contains(searchQuery) || $0.prompt.contains(searchQuery) || $0.tags.contains(searchQuery) }
                }
            }
        }
    }
    
}

#Preview {
    SearchSongsView()
        .environmentObject(TrackViewModel())
        .environmentObject(MusicPlayerViewModel())
}
