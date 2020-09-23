//
//  File.swift
//  
//
//  Created by 👽 on 8/8/20.
//

import Foundation

public enum Torrents {
    public struct GetTorrentsRequest: Encodable {
        let ids: TorrentSet?
        let fields: [TorrentField]

        init(ids: TorrentSet?) {
            self.ids = ids
            self.fields = [
                .activityDate,
                .addedDate,
                .bandwidthPriority,
                .comment,
                .corruptEver,
                .creator,
                .dateCreated,
                .desiredAvailable,
                .doneDate,
                .downloadDir,
                .downloadedEver,
                .downloadLimit,
                .downloadLimited,
                .editDate,
                .error,
                .errorString,
                .eta,
                .etaIdle,
                .files,
                .fileStats,
                .hashString,
                .haveUnchecked,
                .haveValid,
                .honorsSessionLimits,
                .id,
                .isFinished,
                .isPrivate,
                .isStalled,
                .labels,
                .leftUntilDone,
                .magnetLink,
                .manualAnnounceTime,
                .maxConnectedPeers,
                .metadataPercentComplete,
                .name,
                .peerLimit,
                .peers,
                .peersConnected,
                .peersFrom,
                .peersGettingFromUs,
                .peersSendingToUs,
                .percentDone,
                .pieces,
                .pieceCount,
                .pieceSize,
                .priorities,
                .queuePosition,
                .rateDownload,
                .rateUpload,
                .recheckProgress,
                .secondsDownloading,
                .secondsSeeding,
                .seedIdleLimit,
                .seedIdleMode,
                .seedRatioLimit,
                .seedRatioMode,
                .sizeWhenDone,
                .startDate,
                .status,
                .trackers,
                .trackerStats,
                .totalSize,
                .torrentFile,
                .uploadedEver,
                .uploadLimit,
                .uploadLimited,
                .uploadRatio,
                .wanted,
                .webseeds,
                .webseedsSendingToUs
            ]
        }

        init(ids: TorrentSet?, fields: [TorrentField]) {
            self.ids = ids
            self.fields = fields
        }
    }

    public struct GetTorrentsResponse: Decodable {
        public let torrents: [Torrent]
    }

    public static func getTorrents() -> Request<GetTorrentsRequest, GetTorrentsResponse> {
        return self.getTorrents(ids: nil)
    }

    public static func getTorrent(id: TorrentIdentifier) -> Request<GetTorrentsRequest, GetTorrentsResponse> {
        return self.getTorrents(ids: .identifiers([id]))
    }

    public static func getTorrents(ids: TorrentSet?) -> Request<GetTorrentsRequest, GetTorrentsResponse> {
        let torrents = GetTorrentsRequest(ids: ids)

        let request = Request<GetTorrentsRequest, GetTorrentsResponse>(method: "torrent-get", arguments: torrents)

        return request
    }

    public struct AddTorrentRequest: Encodable {
        let metainfo: String
    }

    public enum AddTorrentResponse: Decodable {
        public struct Torrent: Decodable {
            let hashString: String
            let id: Int
            let name: String
        }

        case added(Torrent)
        case duplicate(Torrent)

        enum CodingKeys: String, CodingKey {
            case added = "torrent-added"
            case duplicate = "torrent-duplicate"
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            switch ((try? container.decode(Torrent.self, forKey: .added),
                     try? container.decode(Torrent.self, forKey: .duplicate))) {
            case (let added?, nil):
                self = .added(added)
            case (nil, let duplicate?):
                self = .duplicate(duplicate)
            default:
                let context = DecodingError.Context(codingPath: decoder.codingPath,
                                                    debugDescription: "Invalid type")

                throw DecodingError.dataCorrupted(context)
            }
        }
    }

    public static func addTorrent(_ torrent: String) -> Request<AddTorrentRequest, AddTorrentResponse> {
        let addTorrent = AddTorrentRequest(metainfo: torrent)

        let request = Request<AddTorrentRequest, AddTorrentResponse>(method: "torrent-add", arguments: addTorrent)

        return request
    }

    public struct StartTorrentsRequest: Encodable {
        let ids: TorrentSet?
    }

    public static func startTorrents() -> Request<StartTorrentsRequest, None> {
        return self.startTorrents(ids: nil)
    }

    public static func startTorrent(id: TorrentIdentifier) -> Request<StartTorrentsRequest, None> {
        return self.startTorrents(ids: .identifiers([id]))
    }

    public static func startTorrents(ids: TorrentSet?) -> Request<StartTorrentsRequest, None> {
        return Request<StartTorrentsRequest, None>(method: "torrent-start", arguments: StartTorrentsRequest(ids: ids))
    }

    public struct StopTorrentsRequest: Encodable {
        let ids: TorrentSet?
    }

    public static func stopTorrents() -> Request<StopTorrentsRequest, None> {
        return self.stopTorrents(ids: nil)
    }

    public static func stopTorrent(id: TorrentIdentifier) -> Request<StopTorrentsRequest, None> {
        return self.stopTorrents(ids: .identifiers([id]))
    }

    public static func stopTorrents(ids: TorrentSet?) -> Request<StopTorrentsRequest, None> {
        return Request<StopTorrentsRequest, None>(method: "torrent-stop", arguments: StopTorrentsRequest(ids: ids))
    }
}
