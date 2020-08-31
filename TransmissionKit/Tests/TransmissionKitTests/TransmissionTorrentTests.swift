import XCTest
@testable import TransmissionKit

final class TransmissionTorrentTests: XCTestCase {
    func testDecode() {
        let torrentJSONData = """
            {
              "activityDate": 1589598836,
              "addedDate": 1589591874,
              "bandwidthPriority": 0,
              "comment": "Ubuntu CD releases.ubuntu.com",
              "corruptEver": 0,
              "creator": "",
              "dateCreated": 1581514856,
              "desiredAvailable": 861700096,
              "doneDate": 0,
              "downloadDir": "/Users/chead/Downloads",
              "downloadLimit": 3096,
              "downloadLimited": false,
              "downloadedEver": 59106190,
              "error": 0,
              "errorString": "",
              "eta": -2,
              "etaIdle": -1,
              "fileStats": [
                {
                  "bytesCompleted": 50561024,
                  "priority": 0,
                  "wanted": true
                }
              ],
              "fileStats": [
                {
                  "bytesCompleted": 50561024,
                  "priority": 0,
                  "wanted": true
                }
              ],
              "files": [
                {
                  "bytesCompleted": 50561024,
                  "length": 912261120,
                  "name": "ubuntu-18.04.4-live-server-amd64.iso"
                }
              ],
              "files": [
                {
                  "bytesCompleted": 50561024,
                  "length": 912261120,
                  "name": "ubuntu-18.04.4-live-server-amd64.iso"
                }
              ],
              "hashString": "e73108cbd628fee5cf203acdf668c5bf45d07810",
              "haveUnchecked": 3899392,
              "haveValid": 46661632,
              "honorsSessionLimits": true,
              "id": 1,
              "isFinished": false,
              "isPrivate": false,
              "isStalled": false,
              "leftUntilDone": 861700096,
              "magnetLink": "magnet:?xt=urn:btih:e73108cbd628fee5cf203acdf668c5bf45d07810&dn=ubuntu-18.04.4-live-server-amd64.iso&tr=https%3A%2F%2Ftorrent.ubuntu.com%2Fannounce&tr=https%3A%2F%2Fipv6.torrent.ubuntu.com%2Fannounce",
              "manualAnnounceTime": -1,
              "maxConnectedPeers": 60,
              "metadataPercentComplete": 1,
              "name": "ubuntu-18.04.4-live-server-amd64.iso",
              "peer-limit": 60,
              "peers": [
                {
                  "address": "37.189.114.32",
                  "clientIsChoked": true,
                  "clientIsInterested": false,
                  "clientName": "qBittorrent 4.2.2",
                  "flagStr": "TEX",
                  "isDownloadingFrom": false,
                  "isEncrypted": true,
                  "isIncoming": false,
                  "isUTP": true,
                  "isUploadingTo": false,
                  "peerIsChoked": true,
                  "peerIsInterested": false,
                  "port": 51666,
                  "progress": 0,
                  "rateToClient": 0,
                  "rateToPeer": 0
                }
              ],
              "peersConnected": 59,
              "peersFrom": {
                "fromCache": 0,
                "fromDht": 0,
                "fromIncoming": 0,
                "fromLpd": 0,
                "fromLtep": 0,
                "fromPex": 59,
                "fromTracker": 0
              },
              "peersFrom": {
                "fromCache": 0,
                "fromDht": 0,
                "fromIncoming": 0,
                "fromLpd": 0,
                "fromLtep": 0,
                "fromPex": 59,
                "fromTracker": 0
              },
              "peersGettingFromUs": 0,
              "peersSendingToUs": 0,
              "percentDone": 0.0554,
              "pieceCount": 1740,
              "pieceSize": 524288,
              "pieces": "gIAAABgAQAEAABAEAAAAAAAAAABIAACAAgBAAgCARAAAAAAAQAAQAAAAAAAAAAAIAAAoASAIAAAAAAAgAAAAAQAAIRAAAAAABAAGAAAAAAAQEAAABAAAAAIAAAAAAAAAAAAAAAAgAACAEAoAAAIAAAAgAARABEAIAAAAAAAAAABAAAABBAAAAAAAAAAAAAAAAAABgAAAAAQAAAAAAERAQYgAIAAAIAQCAAAAAwEAAAQAAAACAgAQQAQAAIAABEAQgAAAAAAAAAAAgACAgAAAQAAAAAAADABAAFA=",
              "priorities": [
                0
              ],
              "priorities": [
                0
              ],
              "queuePosition": 0,
              "rateDownload": 0,
              "rateUpload": 0,
              "recheckProgress": 0,
              "secondsDownloading": 63982,
              "secondsSeeding": 0,
              "seedIdleLimit": 30,
              "seedIdleMode": 0,
              "seedRatioLimit": 2,
              "seedRatioMode": 0,
              "sizeWhenDone": 912261120,
              "startDate": 1589675409,
              "status": 4,
              "torrentFile": "/Users/chead/Library/Application Support/Transmission/Torrents/ubuntu-18.04.4-live-server-amd64.iso.e73108cbd628fee5.torrent",
              "totalSize": 912261120,
              "trackerStats": [
                {
                  "announce": "https://torrent.ubuntu.com/announce",
                  "announceState": 1,
                  "downloadCount": 23877,
                  "hasAnnounced": true,
                  "hasScraped": true,
                  "host": "https://torrent.ubuntu.com:443",
                  "id": 0,
                  "isBackup": false,
                  "lastAnnouncePeerCount": 50,
                  "lastAnnounceResult": "Success",
                  "lastAnnounceStartTime": 1589740255,
                  "lastAnnounceSucceeded": true,
                  "lastAnnounceTime": 1589740257,
                  "lastAnnounceTimedOut": false,
                  "lastScrapeResult": "Tracker gave HTTP response code 503 (Service Unavailable)",
                  "lastScrapeStartTime": 1589738430,
                  "lastScrapeSucceeded": true,
                  "lastScrapeTime": 1589740257,
                  "lastScrapeTimedOut": 0,
                  "leecherCount": 20,
                  "nextAnnounceTime": 1589742057,
                  "nextScrapeTime": 1589742060,
                  "scrape": "https://torrent.ubuntu.com/scrape",
                  "scrapeState": 1,
                  "seederCount": 1611,
                  "tier": 0
                }
              ],
              "trackers": [
                {
                  "announce": "https://torrent.ubuntu.com/announce",
                  "id": 0,
                  "scrape": "https://torrent.ubuntu.com/scrape",
                  "tier": 0
                }
              ],
              "uploadLimit": 50,
              "uploadLimited": false,
              "uploadRatio": 0,
              "uploadedEver": 0,
              "wanted": [
                1
              ],
              "wanted": [
                1
              ],
              "webseeds": [],
              "webseeds": [],
              "webseedsSendingToUs": 0
            }
        """.data(using: .utf8)!

        let decodedTorrent = try! JSONDecoder().decode(Torrent.self, from: torrentJSONData)
        
        XCTAssertFalse(decodedTorrent.uploadLimited)
    }

    static var allTests = [
        ("testDecode", testDecode),
    ]
}
