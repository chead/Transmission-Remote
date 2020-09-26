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

    convenience init(torrent: Torrent, service: TransmissionService, managedObjectContext: NSManagedObjectContext) {
        guard let transmissionTorrentEntity = NSEntityDescription.entity(forEntityName: "TransmissionTorrent", in: managedObjectContext)
        else { fatalError("Failed to initialize NSEntityDescription: TransmissionTorrent") }

        self.init(entity: transmissionTorrentEntity, insertInto: managedObjectContext)

        self.setFields(torrent: torrent, service: service)
    }

    private func setFields(torrent: Torrent, service: TransmissionService) {
        self.id = torrent.id
        self.hashString = torrent.hashString
        self.name = torrent.name
        self.progress = torrent.percentDone
        self.service = service
        self.added = torrent.addedDate
        self.activity = torrent.activityDate

        switch torrent.status {
        case .stopped: self.status = .stopped
        case .checkingQueued: self.status = .checkingQueued
        case .checking: self.status = .checking
        case .downloadingQueued: self.status = .downloadingQueued
        case .downloading: self.status = .downloading
        case .seedingQueued: self.status = .seedingQueued
        case .seeding: self.status = .seeding
        }
    }

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

    func update(completion: @escaping () -> Void) {
        self.service.client.make(request: Torrents.getTorrent(id: .id(id)), completion: { (result) in
            switch result {
            case .success(let result):
                guard let remoteTorrent = result.arguments.torrents.first else { break }

                self.setFields(torrent: remoteTorrent, service: self.service)

                do {
                    try self.managedObjectContext!.save()
                } catch {
                    fatalError("Failed to save NSManagedObjectContext: \(error.localizedDescription)")
                }

                break
            case .failure(_):
                break
            }

            completion()
        })
    }
}
