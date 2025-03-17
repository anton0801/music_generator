import SwiftUI
import SDWebImageSwiftUI

struct DetailsMusicPlayerView: View {
    
    @EnvironmentObject var trackViewModel: TrackViewModel
    @EnvironmentObject var playerViewModel: MusicPlayerViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("back_btn")
                }
                Spacer()
                Text("Playing song")
                    .font(.custom("NunitoSans-12ptExtraLight_Bold", size: 24))
                    .foregroundColor(.white)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.init(red: 213/255, green: 34/255, blue: 53/255))
            
            WebImage(url: URL(string: playerViewModel.currentTrack?.imageUrl ?? ""))
                .resizable()
                .frame(width: 240, height: 240)
                .cornerRadius(8)
            
            Text(playerViewModel.currentTrack?.title ?? "No track")
                .font(.custom("NunitoSans-Bold", size: 20))
                .foregroundColor(.black)
            Text(playerViewModel.currentTrack?.author ?? "No track")
                .font(.custom("NunitoSans-Regular", size: 16))
                .foregroundColor(.black)
            
            Spacer()
            
            HStack {
                Text(formatTime(playerViewModel.currentTime))
                    .font(.custom("NunitoSans-Regular", size: 16))
                    .foregroundColor(Color.init(red: 213/255, green: 34/255, blue: 53/255))
                Spacer()
                Text(formatTime(playerViewModel.duration))
                    .font(.custom("NunitoSans-Regular", size: 16))
                    .foregroundColor(Color.init(red: 213/255, green: 34/255, blue: 53/255))
            }
            .padding(.horizontal, 52)
            .padding(.bottom, 12)
            
            Slider(
                value: $playerViewModel.currentTime,
                in: 0...(playerViewModel.duration > 0 ? playerViewModel.duration : 1), // Минимум 1, если duration <= 0
                step: 1.0
            ) { isEditing in
                if !isEditing {
                    playerViewModel.seek(to: playerViewModel.currentTime)
                }
            }
            .disabled(playerViewModel.duration <= 0)
            .padding(.horizontal, 42)
            
            HStack {
                Spacer()
                Button {
                    playerViewModel.playPreviousTrack()
                } label: {
                    Image("music_red_prev")
                }
                Spacer()
                
                Button {
                    if !playerViewModel.isPlaying {
                        if let track = playerViewModel.currentTrack {
                            playerViewModel.playTrack(track)
                        }
                    } else {
                        playerViewModel.pause()
                    }
                } label: {
                    if playerViewModel.isPlaying {
                        Image("btn_pause_red")
                    } else {
                        Image("btn_play_red")
                    }
                }
                
                Spacer()
                Button {
                    playerViewModel.playNextTrack()
                } label: {
                    Image("music_red_next")
                }
                Spacer()
            }
        }
        .onAppear {
            playerViewModel.setTracks(trackViewModel.tracks)
        }
    }
}

#Preview {
    DetailsMusicPlayerView()
        .environmentObject(MusicPlayerViewModel())
        .environmentObject(TrackViewModel())
}
