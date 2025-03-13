import Foundation

struct Track: Identifiable, Codable {
    let id: String
    let title: String
    let author: String
    let tags: String
    let audioUrl: String
    var localAudioPath: String? = nil // Локальный путь после скачивания
    let imageUrl: String
    let createTime: Int64
    let prompt: String
    var status: TrackStatus = .processing
}

enum TrackStatus: String, Codable {
    case processing
    case ready
    case downloaded
}
