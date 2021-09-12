//
//  TransmissionSession.swift
//  Transmission Remote
//
//  Created by 👽 on 8/31/21.
//  Copyright © 2021 chead. All rights reserved.
//

import Foundation
import TransmissionKit

class TransmissionSession {
    let transmissionClient: TransmissionClient
    let transmissionService: TransmissionService

    lazy private var client: Client = {
        var credentials: Credentials?

        if let transmissionCredentials = transmissionClient.credentials {
            credentials = Credentials(username: transmissionCredentials.username, password: transmissionCredentials.password)
        }

        return Client(host: transmissionService.host, port: "\(transmissionService.port)", credentials: credentials)
    }()

    init(transmissionClient: TransmissionClient, transmissionService: TransmissionService) {
        self.transmissionClient = transmissionClient
        self.transmissionService = transmissionService
    }

    func getTorrents(completion: @escaping () -> Void) {
        self.client.make(request: Torrents.getTorrents()) { (result) in
            switch result {
            case .success(let result):
                for localTorrent in self.transmissionService.torrents {
                    self.transmissionService.managedObjectContext?.delete(localTorrent)
                }

                for remoteTorrent in result.arguments.torrents {
                    let _ = TransmissionTorrent(torrent: remoteTorrent, service: self.transmissionService, managedObjectContext: self.transmissionService.managedObjectContext!)
                }

                do {
                    try self.transmissionService.managedObjectContext!.save()
                } catch {
                    fatalError("Failed to save NSManagedObjectContext: \(error.localizedDescription)")
                }

            case .failure(let error):
                print("\(error.localizedDescription)")
            }

            completion()
        }
    }

    func startTorrent(id: Int, completion: @escaping (Bool) -> Void) {
        self.client.make(request: Torrents.startTorrent(id: .id(id))) { (result) in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }

    func stopTorrent(id: Int, completion: @escaping (Bool) -> Void) {
        self.client.make(request: Torrents.stopTorrent(id: .id(id))) { (result) in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
}

