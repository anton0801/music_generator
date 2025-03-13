import SwiftUI
import SDWebImageSwiftUI

struct MiniPlayer: View {
    
    @EnvironmentObject var playerViewModel: MusicPlayerViewModel
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: playerViewModel.currentTrack?.imageUrl ?? ""))
                .resizable()
                .frame(width: 52, height: 52)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(playerViewModel.currentTrack?.title ?? "No track")
                    .font(.custom("NunitoSans-Regular", size: 20))
                    .foregroundColor(.white)
                Text(playerViewModel.currentTrack?.author ?? "No track")
                    .font(.custom("NunitoSans-Regular", size: 16))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            if playerViewModel.isPlaying {
                Button { playerViewModel.pause() }
                label: {
                    Image("pause_btn")
                }
                .disabled(playerViewModel.currentTrack == nil)
            } else {
                Button { playerViewModel.playTrack(playerViewModel.currentTrack!) }
                label: {
                    Image("play_btn")
                }.disabled(playerViewModel.currentTrack == nil)
            }
            
        }
        .padding()
        .background(Color.init(red: 213/255, green: 34/255, blue: 53/255))
    }
}

#Preview {
    MiniPlayer()
        .environmentObject(MusicPlayerViewModel())
}
