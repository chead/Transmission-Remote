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

//    public struct SetTorrentsPriorityHighRequest: Encodable {
//        let ids: TorrentSet?
//        let files: [Int]
//
//        public enum  CodingKeys: String, CodingKey {
//            case ids = "ids"
//            case files = "priority-high"
//        }
//    }
//
//    public static func setTorrentsPriorityHigh(ids: TorrentSet?, files: [Int]) -> Request<SetTorrentsPriorityHighRequest, None> {
//        return Request<SetTorrentsPriorityHighRequest, None>(method: "torrent-set", arguments: SetTorrentsPriorityHighRequest(ids: ids, files: files))
//    }

    public struct SetTorrentsUploadLimitedRequest: Encodable {
        let ids: TorrentSet?
        let uploadLimited: Bool
    }

    public static func setTorrentsUploadLimited(limited: Bool) -> Request<SetTorrentsUploadLimitedRequest, None> {
        return self.setTorrentsUploadLimited(ids: nil, limited: limited)
    }

    public static func setTorrentUploadLimited(id: TorrentIdentifier, limited: Bool) -> Request<SetTorrentsUploadLimitedRequest, None> {
        return self.setTorrentsUploadLimited(ids: .identifiers([id]), limited: limited)
    }

    public static func setTorrentsUploadLimited(ids: TorrentSet?, limited: Bool) -> Request<SetTorrentsUploadLimitedRequest, None> {
        return Request<SetTorrentsUploadLimitedRequest, None>(method: "torrent-set", arguments: SetTorrentsUploadLimitedRequest(ids: ids, uploadLimited: limited))
    }

    public struct SetTorrentsDownloadLimitedRequest: Encodable {
        let ids: TorrentSet?
        let downloadLimited: Bool
    }

    public static func setTorrentsDownloadLimited(limited: Bool) -> Request<SetTorrentsDownloadLimitedRequest, None> {
        return self.setTorrentsDownloadLimited(ids: nil, limited: limited)
    }

    public static func setTorrentDownloadLimited(id: TorrentIdentifier, limited: Bool) -> Request<SetTorrentsDownloadLimitedRequest, None> {
        return self.setTorrentsDownloadLimited(ids: .identifiers([id]), limited: limited)
    }

    public static func setTorrentsDownloadLimited(ids: TorrentSet?, limited: Bool) -> Request<SetTorrentsDownloadLimitedRequest, None> {
        return Request<SetTorrentsDownloadLimitedRequest, None>(method: "torrent-set", arguments: SetTorrentsDownloadLimitedRequest(ids: ids, downloadLimited: limited))
    }

    public struct SetTorrentsUploadLimitRequest: Encodable {
        let ids: TorrentSet?
        let uploadLimit: Int
    }

    public static func setTorrentsUploadLimit(limit: Int) -> Request<SetTorrentsUploadLimitRequest, None> {
        return self.setTorrentsUploadLimit(ids: nil, limit: limit)
    }

    public static func setTorrentUploadLimited(id: TorrentIdentifier, limit: Int) -> Request<SetTorrentsUploadLimitRequest, None> {
        return self.setTorrentsUploadLimit(ids: .identifiers([id]), limit: limit)
    }

    public static func setTorrentsUploadLimit(ids: TorrentSet?, limit: Int) -> Request<SetTorrentsUploadLimitRequest, None> {
        return Request<SetTorrentsUploadLimitRequest, None>(method: "torrent-set", arguments: SetTorrentsUploadLimitRequest(ids: ids, uploadLimit: limit))
    }

    public struct SetTorrentsDownloadLimitRequest: Encodable {
        let ids: TorrentSet?
        let downloadLimit: Int
    }

    public static func setTorrentsDownloadLimit(limit: Int) -> Request<SetTorrentsDownloadLimitRequest, None> {
        return self.setTorrentsDownloadLimit(ids: nil, limit: limit)
    }

    public static func setTorrentDownloadLimited(id: TorrentIdentifier, limit: Int) -> Request<SetTorrentsDownloadLimitRequest, None> {
        return self.setTorrentsDownloadLimit(ids: .identifiers([id]), limit: limit)
    }

    public static func setTorrentsDownloadLimit(ids: TorrentSet?, limit: Int) -> Request<SetTorrentsDownloadLimitRequest, None> {
        return Request<SetTorrentsDownloadLimitRequest, None>(method: "torrent-set", arguments: SetTorrentsDownloadLimitRequest(ids: ids, downloadLimit: limit))
    }
}
