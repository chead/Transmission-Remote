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

    func getTorrents(completion: @escaping (Result<[TransmissionTorrent], Error>) -> Void) {
        self.client.make(request: Torrents.getTorrents()) { (result) in
            switch result {
            case .success(let result):
                let transmissionTorrents = result.arguments.torrents.map { TransmissionTorrent(torrent: $0) }

                completion(.success(transmissionTorrents))

            case .failure(let error):
                completion(.failure(error))
            }
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

