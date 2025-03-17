import Foundation
import AVFoundation

class MusicPlayerViewModel: ObservableObject {
    @Published var currentTrack: Track?
    @Published var currentTime: Double = 0.0 // Текущее время в секундах
    @Published var duration: Double = 1.0   // Общая длительность в секундах
    private var player: AVPlayer?
    private var timeObserver: Any?
    @Published var isPlaying = false
    @Published private var tracks: [Track] = [] // Список всех треков
        
    // Инициализация с передачей списка треков
    func setTracks(_ tracks: [Track]) {
        self.tracks = tracks
    }
    
    func playTrack(_ track: Track) {
        stop() // Останавливаем текущий трек, если он есть
        currentTrack = track
        isPlaying = true
        
        let url = track.localAudioPath != nil ? URL(fileURLWithPath: track.localAudioPath!) : URL(string: track.audioUrl)!
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        let duration = playerItem.asset.duration.seconds
        
        if duration.isFinite {
            self.duration = duration
        }
        
        setupTimeObserver()
        
        player?.play()
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    func stop() {
        player?.pause()
        player = nil
        currentTrack = nil
        currentTime = 0.0
        duration = 0.0
        removeTimeObserver()
        isPlaying = false
    }
    
    // Перемотка трека на заданное время
    func seek(to time: Double) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 1)
        player?.seek(to: cmTime)
        currentTime = time
    }
    
    private func setupTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currentTime = time.seconds
        }
    }
    
    private func removeTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
    
    func playNextTrack() {
        guard let current = currentTrack, !tracks.isEmpty else { return }
        if let currentIndex = tracks.firstIndex(where: { $0.id == current.id }),
           currentIndex + 1 < tracks.count {
            playTrack(tracks[currentIndex + 1])
        }
    }
    
    // Переключение на предыдущий трек
    func playPreviousTrack() {
        guard let current = currentTrack, !tracks.isEmpty else { return }
        if let currentIndex = tracks.firstIndex(where: { $0.id == current.id }),
           currentIndex > 0 {
            playTrack(tracks[currentIndex - 1])
        }
    }
    
    deinit {
        removeTimeObserver()
    }
}

// Форматирование времени в минуты:секунды
func formatTime(_ seconds: Double) -> String {
    let minutes = Int(seconds) / 60
    let remainingSeconds = Int(seconds) % 60
    return String(format: "%d:%02d", minutes, remainingSeconds)
}
