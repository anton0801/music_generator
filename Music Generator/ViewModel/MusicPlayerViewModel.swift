import Foundation
import AVFoundation

class MusicPlayerViewModel: ObservableObject {
    
    @Published var currentTrack: Track?
    private var player: AVPlayer?
    
    @Published var isPlaying = false
    
    func playTrack(_ track: Track) {
        currentTrack = track
        let url = track.localAudioPath != nil ? URL(fileURLWithPath: track.localAudioPath!) : URL(string: track.audioUrl)!
        player = AVPlayer(url: url)
        player?.play()
        isPlaying = true
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    func stop() {
        player?.pause()
        player = nil
        currentTrack = nil
        isPlaying = false
    }
    
}
