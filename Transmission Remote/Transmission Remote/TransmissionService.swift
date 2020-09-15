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

    func addCredentials(username: String, password: String) {
        let credentials = Credentials(username: username, password: password)

        do {
            let credentialsData = try JSONEncoder().encode(credentials)

            _ = Keychain.save(key: self.uuid.uuidString, data: credentialsData)
        } catch {
            fatalError("Failed to encode credentials: \(error.localizedDescription)")
        }
    }

    func udpateCredentials(username: String, password: String) {
        let credentials = Credentials(username: username, password: password)

        do {
            let credentialsData = try JSONEncoder().encode(credentials)

            _ = Keychain.update(key: self.uuid.uuidString, data: credentialsData)
        } catch {
            fatalError("Failed to encode credentials: \(error.localizedDescription)")
        }
    }

    private func getTorrents(completion: @escaping (Result<[Torrent], Error>) -> Void) {
        var credentials: Credentials?

        if let keychainData = Keychain.load(key: self.uuid.uuidString) {
            do {
                credentials = try JSONDecoder().decode(Credentials.self, from: keychainData)
            } catch {}
        }

        let transmissionClient = Client(host: host, port: port, credentials: credentials)

        transmissionClient.make(request: Torrents.getTorrents(), completion: { (result) in
            switch result {
            case .success(let result):
                completion(.success(result.arguments.torrents))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    func refreshTorrents(completion: @escaping () -> Void) {
        self.getTorrents { (result) in
            switch result {
            case .success(let torrents):
                for transmissionTorrent in self.torrents {
                    self.managedObjectContext?.delete(transmissionTorrent)
                }

                for torrent in torrents {
                    guard
                        let transmissionTorrent = NSEntityDescription.insertNewObject(forEntityName: "TransmissionTorrent", into: self.managedObjectContext!) as? TransmissionTorrent
                        else { fatalError("Failed to initialize NSEntityDescription: TransmissionTorrent") }

                    transmissionTorrent.id = "\(torrent.id)"
                    transmissionTorrent.name = torrent.name
                    transmissionTorrent.service = self
                }

                do {
                    try self.managedObjectContext!.save()
                } catch {
                    fatalError("Failed to save NSManagedObjectContext: \(error.localizedDescription)")
                }

            case .failure(let error):
                print(error.localizedDescription)
            }

            completion()
        }
    }

    override public func prepareForDeletion() {
        super.prepareForDeletion()

        let _ = Keychain.delete(key: self.uuid.uuidString)
    }
}
