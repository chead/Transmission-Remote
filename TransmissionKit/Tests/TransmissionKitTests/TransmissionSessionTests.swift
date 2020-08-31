import XCTest
@testable import TransmissionKit

final class TransmissionSessionTests: XCTestCase {    
    func testDecode() {
        let sessionJSONData = """
            {
              "alt-speed-down": 10,
              "alt-speed-enabled": false,
              "alt-speed-time-begin": 1140,
              "alt-speed-time-day": 127,
              "alt-speed-time-enabled": false,
              "alt-speed-time-end": 300,
              "alt-speed-up": 10,
              "blocklist-enabled": false,
              "blocklist-size": 0,
              "blocklist-url": "http://www.example.com/blocklist",
              "cache-size-mb": 4,
              "config-dir": "/Users/chead/Library/Application Support/Transmission",
              "dht-enabled": true,
              "download-dir": "/Users/chead/Downloads",
              "download-dir-free-space": 12649172992,
              "download-queue-enabled": false,
              "download-queue-size": 3,
              "encryption": "preferred",
              "idle-seeding-limit": 30,
              "idle-seeding-limit-enabled": false,
              "incomplete-dir": "/Users/chead/Downloads",
              "incomplete-dir-enabled": false,
              "lpd-enabled": false,
              "peer-limit-global": 200,
              "peer-limit-per-torrent": 60,
              "peer-port": 51413,
              "peer-port-random-on-start": false,
              "pex-enabled": true,
              "port-forwarding-enabled": true,
              "queue-stalled-enabled": false,
              "queue-stalled-minutes": 30,
              "rename-partial-files": true,
              "rpc-version": 15,
              "rpc-version-minimum": 1,
              "script-torrent-done-enabled": false,
              "script-torrent-done-filename": "",
              "seed-queue-enabled": false,
              "seed-queue-size": 3,
              "seedRatioLimit": 2,
              "seedRatioLimited": false,
              "speed-limit-down": 0,
              "speed-limit-down-enabled": true,
              "speed-limit-up": 0,
              "speed-limit-up-enabled": true,
              "start-added-torrents": true,
              "trash-original-torrent-files": false,
              "units": {
                "memory-bytes": 1000,
                "memory-units": [
                  "KB",
                  "MB",
                  "GB",
                  "TB"
                ],
                "size-bytes": 1000,
                "size-units": [
                  "KB",
                  "MB",
                  "GB",
                  "TB"
                ],
                "speed-bytes": 1000,
                "speed-units": [
                  "KB/s",
                  "MB/s",
                  "GB/s",
                  "TB/s"
                ]
              },
              "utp-enabled": true,
              "version": "2.94 (d8e60ee44f)"
            }
        """.data(using: .utf8)!

        let decodedSession = try! JSONDecoder().decode(Session.self, from: sessionJSONData)
        
        XCTAssertTrue(decodedSession.utpEnabled)
    }

    static var allTests = [
        ("testDecode", testDecode),
    ]
}
