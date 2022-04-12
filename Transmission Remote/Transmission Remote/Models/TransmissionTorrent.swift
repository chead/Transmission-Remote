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

public class TransmissionTorrent {
    enum Status: Int32 {
        case stopped = 0
        case checkingQueued
        case checking
        case downloadingQueued
        case downloading
        case seedingQueued
        case seeding
    }

    var id: Int
    var hashString: String
    var name: String
    var added: Date
    var activity: Date
    var downloadLimit: Int
    var downloadLimited: Bool
    var downloadRate: Int
    var uploadLimit: Int
    var uploadLimited: Bool
    var uploadRate: Int
    var progress: Float
//    var service: TransmissionService
    var status: Status
    var files: Set<TransmissionFile>

    init(torrent: Torrent/*, service: TransmissionService*/) {
//        guard let transmissionTorrentEntity = NSEntityDescription.entity(forEntityName: "TransmissionTorrent", in: managedObjectContext)
//        else { fatalError("Failed to initialize NSEntityDescription: TransmissionTorrent") }

//        self.init(entity: transmissionTorrentEntity, insertInto: managedObjectContext)

        for file in torrent.files {
//            let transmissionFile = TransmissionFile(file: file, torrent: self, managedObjectContext: managedObjectContext)
//
//            self.files.insert(transmissionFile)
        }

        self.id = torrent.id
        self.hashString = torrent.hashString
        self.name = torrent.name
        self.progress = torrent.percentDone
//        self.service = service
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

        self.downloadLimit = torrent.downloadLimit
        self.downloadLimited = torrent.downloadLimited
        self.downloadRate = torrent.rateDownload
        self.uploadLimit = torrent.uploadLimit
        self.uploadLimited = torrent.uploadLimited
        self.uploadRate = torrent.rateUpload
        self.files = []
    }

    func start(completion: @escaping (Bool) -> Void) {
//        self.service.client.make(request: Torrents.startTorrent(id: .id(id))) { (result) in
//            switch result {
//            case .success(_):
//                completion(true)
//            case .failure(_):
//                completion(false)
//            }
//        }
    }

    func stop(completion: @escaping (Bool) -> Void) {
//        self.service.client.make(request: Torrents.stopTorrent(id: .id(id))) { (result) in
//            switch result {
//            case .success(_):
//                completion(true)
//            case .failure(_):
//                completion(false)
//            }
//        }
    }

    func uploadLimited(limited: Bool, completion: @escaping (Bool) -> Void) {
//        self.service.client.make(request: Torrents.setTorrentsUploadLimited(limited: limited)) { (result) in
//            switch result {
//            case .success(_):
//                completion(true)
//            case .failure(_):
//                completion(false)
//            }
//        }
    }

    func downloadLimited(limited: Bool, completion: @escaping (Bool) -> Void) {
//        self.service.client.make(request: Torrents.setTorrentsDownloadLimited(limited: limited)) { (result) in
//            switch result {
//            case .success(_):
//                completion(true)
//            case .failure(_):
//                completion(false)
//            }
//        }
    }

    func uploadLimit(limit: Int, completion: @escaping (Bool) -> Void) {
//        self.service.client.make(request: Torrents.setTorrentsUploadLimit(limit: limit)) { (result) in
//            switch result {
//            case .success(_):
//                completion(true)
//            case .failure(_):
//                completion(false)
//            }
//        }
    }

    func downloadLimit(limit: Int, completion: @escaping (Bool) -> Void) {
//        self.service.client.make(request: Torrents.setTorrentsDownloadLimit(limit: limit)) { (result) in
//            switch result {
//            case .success(_):
//                completion(true)
//            case .failure(_):
//                completion(false)
//            }
//        }
    }

    func update(completion: @escaping () -> Void) {
//        self.service.client.make(request: Torrents.getTorrent(id: .id(id))) { (result) in
//            switch result {
//            case .success(let result):
//                guard let remoteTorrent = result.arguments.torrents.first else { break }
//
//                self.setFields(torrent: remoteTorrent, service: self.service)
//
//                do {
//                    try self.managedObjectContext!.save()
//                } catch {
//                    fatalError("Failed to save NSManagedObjectContext: \(error.localizedDescription)")
//                }
//
//                break
//            case .failure(_):
//                break
//            }
//
//            completion()
//        }
    }
}
