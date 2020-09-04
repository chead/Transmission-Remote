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
    @NSManaged var torrents: Set<TransmissionTorrent>

    func refreshTorrents(completion: (Error?) -> Void) {
        let transmissionClient = Client(host: host, port: port, credentials: nil)

        transmissionClient.make(request: Torrents.getTorrents(), completion: { (result) in
            switch result {
            case .success(let result):
                for transmissionTorrent in self.torrents {
                    self.managedObjectContext?.delete(transmissionTorrent)
                }

                for torrent in result.arguments.torrents {
                    guard
                        let transmissionTorrent = NSEntityDescription.insertNewObject(forEntityName: "TransmissionTorrent", into: self.managedObjectContext!) as? TransmissionTorrent
                        else { break }

                    transmissionTorrent.id = "\(torrent.id)"
                    transmissionTorrent.name = torrent.name
                    transmissionTorrent.service = self

                    do {
                        try self.managedObjectContext?.save()
                    } catch {
                        fatalError("Failed to save NSManagedObjectContext: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}
