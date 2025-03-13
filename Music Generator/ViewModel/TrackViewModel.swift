import Foundation

class TrackViewModel: ObservableObject {
    @Published var tracks: [Track] = [] {
        didSet {
            saveTracksToUserDefaults()
        }
    }
    @Published var currentTrack: Track?
    
    @Published var generatingTrack = false
    @Published var trackGenerated = false
    
    init() {
        loadTracksFromUserDefaults()
    }

    private func saveTracksToUserDefaults() {
        do {
            let data = try JSONEncoder().encode(tracks)
            UserDefaults.standard.set(data, forKey: "savedTracks")
        } catch {
        }
    }
    
    private func loadTracksFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: "savedTracks") else {
            return
        }
        do {
            tracks = try JSONDecoder().decode([Track].self, from: data)
        } catch {
        }
    }
    
    func generateTrack(prompt: String, style: String, title: String, author: String) async throws {
        let url = URL(string: "https://apibox.erweima.ai/api/v1/generate")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer d22840fd7b2d4d36540e10b5c84ba5ab", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "prompt": prompt,
            "style": style,
            "title": title,
            "customMode": true,
            "instrumental": true,
            "model": "V3_5",
            "callBackUrl": "https://musicsuno.site?method=sunoCallback"
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(SunoResponse.self, from: data)
        let taskId = response.data.taskId
        DispatchQueue.main.async {
            self.generatingTrack = true
        }
        await checkTrackStatus(taskId: taskId, author: author)
    }
    
}

struct SunoResponse: Codable {
    let code: Int
    let msg: String
    let data: SunoData
}

struct SunoData: Codable {
    let taskId: String
}

extension TrackViewModel {
    func checkTrackStatus(taskId: String, author: String) async {
        while true {
            let url = URL(string: "https://musicsuno.site?method=getTrackData&task_id=\(taskId)")!
            let (data, _) = try! await URLSession.shared.data(from: url)
            let response = try! JSONDecoder().decode(TrackResponse.self, from: data)
            
            if response.status == "processing" {
                try! await Task.sleep(nanoseconds: 5_000_000_000) // 5 секунд
            } else {
                let trackData = response.data!.data.first!
                let track = Track(
                    id: trackData.id,
                    title: trackData.title,
                    author: author,
                    tags: trackData.tags,
                    audioUrl: trackData.streamAudioUrl,
                    imageUrl: trackData.imageUrl,
                    createTime: trackData.createTime,
                    prompt: trackData.prompt
                )
                let downloaded = try! await self.downloadTrack(track: track)
                DispatchQueue.main.async {
                    self.trackGenerated = true
                    self.tracks.append(downloaded)
                    self.saveTracksLocally()
                }
                break
            }
        }
    }
}

struct TrackResponse: Codable {
    let code: Int?
    let msg: String?
    var data: TrackDataResponse? = nil
    var status: String? = nil
}

struct TrackDataResponse: Codable {
    let status: String?
    let data: [TrackData]
    let taskId: String
    
    enum CodingKeys: String, CodingKey {
        case data, status
        case taskId = "task_id"
    }
}

struct TrackData: Codable {
    let id: String
    let title: String
    let tags: String
    let streamAudioUrl: String
    let imageUrl: String
    let createTime: Int64
    let prompt: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, tags, prompt
        case streamAudioUrl = "stream_audio_url"
        case imageUrl = "image_url"
        case createTime = "createTime"
    }
}

extension TrackViewModel {
    func downloadTrack(track: Track) async throws -> Track {
        let url = URL(string: track.audioUrl)!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documents.appendingPathComponent("\(track.id).mp3")
        try data.write(to: fileURL)
        
        var updatedTrack = track
        updatedTrack.localAudioPath = fileURL.path
        updatedTrack.status = .downloaded
        if let index = tracks.firstIndex(where: { $0.id == track.id }) {
            DispatchQueue.main.async {
                self.tracks[index] = updatedTrack
                self.saveTracksLocally()
            }
        }
        return updatedTrack
    }
    
    func saveTracksLocally() {
        let data = try? JSONEncoder().encode(tracks)
        UserDefaults.standard.set(data, forKey: "savedTracks")
    }
    
    func loadTracks() {
        if let data = UserDefaults.standard.data(forKey: "savedTracks"),
           let savedTracks = try? JSONDecoder().decode([Track].self, from: data) {
            tracks = savedTracks
        }
    }
}
