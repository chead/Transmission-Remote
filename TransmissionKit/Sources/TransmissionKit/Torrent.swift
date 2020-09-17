//
//  Torrent.swift
//  TransmissionKit
//
//  Created by Christopher Head on 3/21/19.
//

import Foundation

public struct Torrent {
    public struct File: Decodable {
        public let bytesCompleted: Int
        public let length: Int
        public let name: String
    }

    public struct FileStatistics: Decodable {
        public let bytesCompleted: Int
        public let wanted: Bool
        public let priority: Int
    }

    public struct Peer: Decodable {
        public let address: String
        public let clientName: String
        public let clientIsChoked: Bool
        public let clientIsInterested: Bool
        public let flagStr: String
        public let isDownloadingFrom: Bool
        public let isEncrypted: Bool
        public let isIncoming: Bool
        public let isUploadingTo: Bool
        public let isUTP: Bool
        public let peerIsChoked: Bool
        public let peerIsInterested: Bool
        public let port: Int
        public let progress: Float
        public let rateToClient: Int
        public let rateToPeer: Int
    }

    public struct PeersFrom: Decodable {
        public let fromCache: Int
        public let fromDht: Int
        public let fromIncoming: Int
        public let fromLpd: Int
        public let fromLtep: Int
        public let fromPex: Int
        public let fromTracker: Int
    }

    public enum Priority: Int, Decodable {
        case high = 1
        case normal = 0
        case low = -1
    }

    public struct Tracker: Decodable {
        public let announce: String
        public let id: Int
        public let scrape: String
        public let tier: Int
    }

    public struct TrackerStatistics: Decodable {
        public let announce: String
        public let announceState: Int
        public let downloadCount: Int
        public let hasAnnounced: Bool
        public let hasScraped: Bool
        public let host: String
        public let id: Int
        public let isBackup: Bool
        public let lastAnnouncePeerCount: Int
        public let lastAnnounceResult: String
        public let lastAnnounceStartTime: Int
        public let lastAnnounceSucceeded: Bool
        public let lastAnnounceTime: Int
        public let lastAnnounceTimedOut: Bool
        public let lastScrapeResult: String
        public let lastScrapeStartTime: Int
        public let lastScrapeSucceeded: Bool
        public let lastScrapeTime: Int
        public let lastScrapeTimedOut: Int //Bool
        public let leecherCount: Int
        public let nextAnnounceTime: Int
        public let nextScrapeTime: Int
        public let scrape: String
        public let scrapeState: Int
        public let seederCount: Int
        public let tier: Int
    }

    public let activityDate: Date
    public let addedDate: Date
    public let bandwidthPriority: Int
    public let comment: String
    public let corruptEver: Int
    public let creator: String
    public let dateCreated: Int
    public let desiredAvailable: Int
    public let doneDate: Int
    public let downloadDir: String
    public let downloadedEver: Int
    public let downloadLimit: Int
    public let downloadLimited: Bool
    public let error: Int
    public let errorString: String
    public let eta: Int
    public let etaIdle: Int
    public let files: [File]
    public let fileStats: [FileStatistics]
    public let hashString: String
    public let haveUnchecked: Int
    public let haveValid: Int
    public let honorsSessionLimits: Bool
    public let id: Int
    public let isFinished: Bool
    public let isPrivate: Bool
    public let isStalled: Bool
    public let leftUntilDone: Int
    public let magnetLink: String
    public let manualAnnounceTime: Int
    public let maxConnectedPeers: Int
    public let metadataPercentComplete: Float
    public let name: String
    public let peerLimit: Int //peer-limit
    public let peers: [Peer]
    public let peersConnected: Int
    public let peersFrom: PeersFrom
    public let peersGettingFromUs: Int
    public let peersSendingToUs: Int
    public let percentDone: Float
    public let pieces: String
    public let pieceCount: Int
    public let pieceSize: Int
    public let priorities: [Priority]
    public let queuePosition: Int
    public let rateDownload: Int
    public let rateUpload: Int
    public let recheckProgress: Float
    public let secondsDownloading: Int
    public let secondsSeeding: Int
    public let seedIdleLimit: Int
    public let seedIdleMode: Int
    public let seedRatioLimit: Float
    public let seedRatioMode: Int
    public let sizeWhenDone: Int
    public let startDate: Int
    public let status: Int
    public let trackers: [Tracker]
    public let trackerStats: [TrackerStatistics]
    public let totalSize: Int
    public let torrentFile: String
    public let uploadedEver: Int
    public let uploadLimit: Int
    public let uploadLimited: Bool
    public let uploadRatio: Float
    public let wanted: [Int] //[Bool]
    public let webseeds: [String]
    public let webseedsSendingToUs: Int
}

extension Torrent: Decodable {
    public enum  CodingKeys: String, CodingKey {
        case activityDate = "activityDate"
        case addedDate = "addedDate"
        case bandwidthPriority = "bandwidthPriority"
        case comment = "comment"
        case corruptEver = "corruptEver"
        case creator = "creator"
        case dateCreated = "dateCreated"
        case desiredAvailable = "desiredAvailable"
        case doneDate = "doneDate"
        case downloadDir = "downloadDir"
        case downloadedEver = "downloadedEver"
        case downloadLimit = "downloadLimit"
        case downloadLimited = "downloadLimited"
        case error = "error"
        case errorString = "errorString"
        case eta = "eta"
        case etaIdle = "etaIdle"
        case files = "files"
        case fileStats = "fileStats"
        case hashString = "hashString"
        case haveUnchecked = "haveUnchecked"
        case haveValid = "haveValid"
        case honorsSessionLimits = "honorsSessionLimits"
        case id = "id"
        case isFinished = "isFinished"
        case isPrivate = "isPrivate"
        case isStalled = "isStalled"
        case leftUntilDone = "leftUntilDone"
        case magnetLink = "magnetLink"
        case manualAnnounceTime = "manualAnnounceTime"
        case maxConnectedPeers = "maxConnectedPeers"
        case metadataPercentComplete = "metadataPercentComplete"
        case name = "name"
        case peerLimit = "peer-limit"
        case peers = "peers"
        case peersConnected = "peersConnected"
        case peersFrom = "peersFrom"
        case peersGettingFromUs = "peersGettingFromUs"
        case peersSendingToUs = "peersSendingToUs"
        case percentDone = "percentDone"
        case pieces = "pieces"
        case pieceCount = "pieceCount"
        case pieceSize = "pieceSize"
        case priorities = "priorities"
        case queuePosition = "queuePosition"
        case rateDownload = "rateDownload"
        case rateUpload = "rateUpload"
        case recheckProgress = "recheckProgress"
        case secondsDownloading = "secondsDownloading"
        case secondsSeeding = "secondsSeeding"
        case seedIdleLimit = "seedIdleLimit"
        case seedIdleMode = "seedIdleMode"
        case seedRatioLimit = "seedRatioLimit"
        case seedRatioMode = "seedRatioMode"
        case sizeWhenDone = "sizeWhenDone"
        case startDate = "startDate"
        case status = "status"
        case trackers = "trackers"
        case trackerStats = "trackerStats"
        case totalSize = "totalSize"
        case torrentFile = "torrentFile"
        case uploadedEver = "uploadedEver"
        case uploadLimit = "uploadLimit"
        case uploadLimited = "uploadLimited"
        case uploadRatio = "uploadRatio"
        case wanted = "wanted"
        case webseeds = "webseeds"
        case webseedsSendingToUs = "webseedsSendingToUs"
    }
}
