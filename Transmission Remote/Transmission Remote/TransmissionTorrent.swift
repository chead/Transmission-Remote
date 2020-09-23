//
//  TransmissionTorrent.swift
//  Transmission Remote
//
//  Created by 👽 on 8/31/20.
//  Copyright © 2020 chead. All rights reserved.
//

import Foundation
import CoreData
import TransmissionKit

@objc(TransmissionTorrent)

public class TransmissionTorrent: NSManagedObject {
    @objc(Status)

    enum Status: Int32 {
        case stopped = 0
        case checkingQueued
        case checking
        case downloadingQueued
        case downloading
        case seedingQueued
        case seeding
    }

    @NSManaged var id: Int
    @NSManaged var hashString: String
    @NSManaged var name: String
    @NSManaged var added: Date
    @NSManaged var activity: Date
    @NSManaged var progress: Float
    @NSManaged var service: TransmissionService
    @NSManaged var status: Status

    func start(completion: @escaping (Bool) -> Void) {
        self.service.client.make(request: Torrents.startTorrent(id: .id(id)), completion: { (result) in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        })
    }

    func stop(completion: @escaping (Bool) -> Void) {
        self.service.client.make(request: Torrents.stopTorrent(id: .id(id)), completion: { (result) in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        })
    }

    func update() {
        self.service.client.make(request: Torrents.getTorrent(id: .id(id)), completion: { (result) in
            switch result {
            case .success(let result):
                guard let remoteTorrent = result.arguments.torrents.first else { break }

                self.id = remoteTorrent.id
                self.hashString = remoteTorrent.hashString
                self.name = remoteTorrent.name
                self.progress = remoteTorrent.percentDone
                self.added = remoteTorrent.addedDate
                self.activity = remoteTorrent.activityDate

                do {
                    try self.managedObjectContext!.save()
                } catch {
                    fatalError("Failed to save NSManagedObjectContext: \(error.localizedDescription)")
                }

                break
            case .failure(_):
                break
            }
        })
    }
}
