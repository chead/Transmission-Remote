//
//  File.swift
//  
//
//  Created by 👽 on 8/8/20.
//

import Foundation

public enum Torrents {
    public struct TorrentGroup: Decodable{
        public let torrents: [Torrent]
    }

    public struct Torrents: Encodable {
        let ids: TorrentSet?
        let fields: [String]

        init(ids: TorrentSet?) {
            self.ids = ids
            self.fields = [
                "activityDate",
                "addedDate",
                "bandwidthPriority",
                "comment",
                "corruptEver",
                "creator",
                "dateCreated",
                "desiredAvailable",
                "doneDate",
                "downloadDir",
                "downloadedEver",
                "downloadLimit",
                "downloadLimited",
                "editDate",
                "error",
                "errorString",
                "eta",
                "etaIdle",
                "files",
                "fileStats",
                "hashString",
                "haveUnchecked",
                "haveValid",
                "honorsSessionLimits",
                "id",
                "isFinished",
                "isPrivate",
                "isStalled",
                "labels",
                "leftUntilDone",
                "magnetLink",
                "manualAnnounceTime",
                "maxConnectedPeers",
                "metadataPercentComplete",
                "name",
                "peer-limit",
                "peers",
                "peersConnected",
                "peersFrom",
                "peersGettingFromUs",
                "peersSendingToUs",
                "percentDone",
                "pieces",
                "pieceCount",
                "pieceSize",
                "priorities",
                "queuePosition",
                "rateDownload",
                "rateUpload",
                "recheckProgress",
                "secondsDownloading",
                "secondsSeeding",
                "seedIdleLimit",
                "seedIdleMode",
                "seedRatioLimit",
                "seedRatioMode",
                "sizeWhenDone",
                "startDate",
                "status",
                "trackers",
                "trackerStats",
                "totalSize",
                "torrentFile",
                "uploadedEver",
                "uploadLimit",
                "uploadLimited",
                "uploadRatio",
                "wanted",
                "webseeds",
                "webseedsSendingToUs",
                "files",
                "fileStats",
                "labels",
                "peers",
                "peersFrom",
                "pieces",
                "priorities",
                "trackers",
                "trackerStats",
                "wanted",
                "webseeds"
            ]
        }

        init(ids: TorrentSet?, fields: [String]) {
            self.ids = ids
            self.fields = fields
        }
    }

    public static func getTorrents() -> Request<Torrents, TorrentGroup> {
        return self.getTorrents(ids: nil)
    }

    public static func getTorrents(ids: TorrentSet?) -> Request<Torrents, TorrentGroup> {
        let foo = Torrents(ids: ids)

        let request = Request<Torrents, TorrentGroup>(method: "torrent-get", arguments: foo)

        return request
    }

    public static func getTorrent(id: TorrentIdentifier) -> Request<Torrents, TorrentGroup> {
        return self.getTorrents(ids: .identifiers([id]))
    }
}
