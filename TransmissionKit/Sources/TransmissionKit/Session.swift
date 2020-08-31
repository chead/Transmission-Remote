//
//  Session.swift
//  TransmissionKit
//
//  Created by Christopher Head on 3/21/19.
//

import Foundation

public struct Session: Decodable {
    public struct Units {
        public let memoryBytes: Int
        public let memoryUnits: [String]
        public let sizeBytes: Int
        public let sizeUnits: [String]
        public let speedBytes: Int
        public let speedUnits: [String]
    }

    public let altSpeedDown: Int
    public let altSpeedEnabled: Bool
    public let altSpeedTimeBegin: Int
    public let altSpeedTimeDay: Int
    public let altSpeedTimeEnabled: Bool
    public let altSpeedTimeEnd: Int
    public let altSpeedUp: Int
    public let blocklistEnabled: Bool
    public let blocklistSize: Int
    public let blocklistUrl: String
    public let cacheSizeMb: Int
    public let configDir: String
    public let dhtEnabled: Bool
    public let downloadDir: String
    public let downloadDirFreeSpace: Int
    public let downloadQueueEnabled: Bool
    public let downloadQueueSize: Int
    public let encryption: String
    public let idleSeedingLimit: Int
    public let idleSeedingLimitEnabled: Bool
    public let incompleteDir: String
    public let incompleteDirEnabled: Bool
    public let lpdDnabled: Bool
    public let peerLimitGlobal: Int
    public let peerLimitPerTorrent: Int
    public let peerPort: Int
    public let peerPortRandomOnStart: Bool
    public let pexEnabled: Bool
    public let portForwardingEnabled: Bool
    public let queueStalledEnabled: Bool
    public let queueStalledMinutes: Int
    public let renamePartialFiles: Bool
    public let rpcVersion: Int
    public let rpcVersionMinimum: Int
    public let scriptTorrentDoneEnabled: Bool
    public let scriptTorrentDoneFilename: String
    public let seedQueueEnabled: Bool
    public let seedQueueSize: Int
    public let seedRatioLimit: Int
    public let seedRatioLimited: Bool
    public let speedLimitDown: Int
    public let speedLimitDownEnabled: Bool
    public let speedLimitUp: Int
    public let speedLimitUpEnabled: Bool
    public let startAddedTorrents: Bool
    public let trashOriginalTorrentFiles: Bool
    public let units: Units
    public let utpEnabled: Bool
    public let version: String
}

extension Session {
    enum CodingKeys: String, CodingKey {
        case altSpeedDown = "alt-speed-down"
        case altSpeedEnabled = "alt-speed-enabled"
        case altSpeedTimeBegin = "alt-speed-time-begin"
        case altSpeedTimeDay = "alt-speed-time-day"
        case altSpeedTimeEnabled = "alt-speed-time-enabled"
        case altSpeedTimeEnd = "alt-speed-time-end"
        case altSpeedUp = "alt-speed-up"
        case blocklistEnabled = "blocklist-enabled"
        case blocklistSize = "blocklist-size"
        case blocklistUrl = "blocklist-url"
        case cacheSizeMb = "cache-size-mb"
        case configDir = "config-dir"
        case dhtEnabled = "dht-enabled"
        case downloadDir = "download-dir"
        case downloadDirFreeSpace = "download-dir-free-space"
        case downloadQueueEnabled = "download-queue-enabled"
        case downloadQueueSize = "download-queue-size"
        case encryption = "encryption"
        case idleSeedingLimit = "idle-seeding-limit"
        case idleSeedingLimitEnabled = "idle-seeding-limit-enabled"
        case incompleteDir = "incomplete-dir"
        case incompleteDirEnabled = "incomplete-dir-enabled"
        case lpdDnabled = "lpd-enabled"
        case peerLimitGlobal = "peer-limit-global"
        case peerLimitPerTorrent = "peer-limit-per-torrent"
        case peerPort = "peer-port"
        case peerPortRandomOnStart = "peer-port-random-on-start"
        case pexEnabled = "pex-enabled"
        case portForwardingEnabled = "port-forwarding-enabled"
        case queueStalledEnabled = "queue-stalled-enabled"
        case queueStalledMinutes = "queue-stalled-minutes"
        case renamePartialFiles = "rename-partial-files"
        case rpcVersion = "rpc-version"
        case rpcVersionMinimum = "rpc-version-minimum"
        case scriptTorrentDoneEnabled = "script-torrent-done-enabled"
        case scriptTorrentDoneFilename = "script-torrent-done-filename"
        case seedQueueEnabled = "seed-queue-enabled"
        case seedQueueSize = "seed-queue-size"
        case seedRatioLimit = "seedRatioLimit"
        case seedRatioLimited = "seedRatioLimited"
        case speedLimitDown = "speed-limit-down"
        case speedLimitDownEnabled = "speed-limit-down-enabled"
        case speedLimitUp = "speed-limit-up"
        case speedLimitUpEnabled = "speed-limit-up-enabled"
        case startAddedTorrents = "start-added-torrents"
        case trashOriginalTorrentFiles = "trash-original-torrent-files"
        case units = "units"
        case utpEnabled = "utp-enabled"
        case version = "version"
    }
}

extension Session.Units: Decodable {
    enum CodingKeys: String, CodingKey {
        case memoryBytes = "memory-bytes"
        case memoryUnits = "memory-units"
        case sizeBytes = "size-bytes"
        case sizeUnits = "size-units"
        case speedBytes = "speed-bytes"
        case speedUnits = "speed-units"
    }
}
