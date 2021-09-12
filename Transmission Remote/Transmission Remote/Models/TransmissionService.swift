//
//  TransmissionService.swift
//  Transmission Remote
//
//  Created by 👽 on 6/14/20.
//  Copyright © 2020 chead. All rights reserved.
//

import Foundation
import CoreData
import TransmissionKit

@objc(TransmissionService)

public class TransmissionService: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var host: String
    @NSManaged var port: String
    @NSManaged var created: Date
    @NSManaged var uuid: UUID
    @NSManaged var torrents: [TransmissionTorrent]

//    lazy var client: Client = {
//        var credentials: Credentials?
//
//        if let keychainData = Keychain.load(key: self.uuid.uuidString) {
//            do {
//                credentials = try JSONDecoder().decode(Credentials.self, from: keychainData)
//            } catch {}
//        }
//
//         return Client(host: host, port: port, credentials: credentials)
//    }()
//
//    func addCredentials(username: String, password: String) {
//        let credentials = Credentials(username: username, password: password)
//
//        do {
//            let credentialsData = try JSONEncoder().encode(credentials)
//
//            _ = Keychain.save(key: self.uuid.uuidString, data: credentialsData)
//        } catch {
//            fatalError("Failed to encode credentials: \(error.localizedDescription)")
//        }
//    }
//
//    func udpateCredentials(username: String, password: String) {
//        let credentials = Credentials(username: username, password: password)
//
//        do {
//            let credentialsData = try JSONEncoder().encode(credentials)
//
//            _ = Keychain.update(key: self.uuid.uuidString, data: credentialsData)
//        } catch {
//            fatalError("Failed to encode credentials: \(error.localizedDescription)")
//        }
//    }
//
//    func refreshTorrents(completion: @escaping () -> Void) {
//        self.client.make(request: Torrents.getTorrents()) { (result) in
//            switch result {
//            case .success(let result):
//                for localTorrent in self.torrents {
//                    self.managedObjectContext?.delete(localTorrent)
//                }
//
//                for remoteTorrent in result.arguments.torrents {
//                    let _ = TransmissionTorrent(torrent: remoteTorrent, service: self, managedObjectContext: self.managedObjectContext!)
//                }
//
//                do {
//                    try self.managedObjectContext!.save()
//                } catch {
//                    fatalError("Failed to save NSManagedObjectContext: \(error.localizedDescription)")
//                }
//
//            case .failure(let error):
//                print("\(error.localizedDescription)")
//            }
//
//            completion()
//        }
//    }
//
//    func addTorrent(url: URL, completion: @escaping (Bool) -> Void) {
//        do {
//            let encodedTorrent = try Data(contentsOf: url).base64EncodedString()
//
//            self.client.make(request: Torrents.addTorrent(encodedTorrent)) { (result) in
//                switch result {
//                case .success(let response):
//                    switch(response.arguments) {
//                    case .added(_):
//                        completion(true)
//                    case .duplicate(_):
//                        completion(false)
//                    }
//                case .failure(let error):
//                    completion(false)
//                    print("\(error.localizedDescription)")
//                }
//            }
//        } catch {
//            fatalError("Failed to encode torrent data: \(error.localizedDescription)")
//        }
//    }
//
    override public func prepareForDeletion() {
        super.prepareForDeletion()

        let _ = TransmissionCredentials.deleteCredentials(uuid: self.uuid)
    }
}
