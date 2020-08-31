import XCTest
@testable import TransmissionKit

final class SessionTest: XCTestCase {
    @available(iOS 13.0.0, *)
    func testExample() {
        let e = expectation(description: "foo")
        let credentials = Credentials(username: "admin", password: "toor")
//        let client = Client(host: URL(string: "http://localhost:9091/transmission/rpc")!, credentials: credentials)
        let client = Client(host: "localhost", port: "9091", credentials: credentials)

        let identifier = TorrentIdentifier(1)
        let request = Torrents.getTorrent(id: identifier)

        client.make(request: request) { (result) in
            switch result {
            case .success(let session): break
            case .failure(let error): break
            }

            e.fulfill()
        }



        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    @available(iOS 13.0.0, *)
    static var allTests = [
        ("testExample", testExample),
    ]
}
