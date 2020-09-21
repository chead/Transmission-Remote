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
    @NSManaged var id: Int
    @NSManaged var hashString: String
    @NSManaged var name: String
    @NSManaged var added: Date
    @NSManaged var activity: Date
    @NSManaged var progress: Float
    @NSManaged var service: TransmissionService

    func start() {
        self.service.client.make(request: Torrents.startTorrent(id: .id(id)), completion: { (_) in })
    }

    func stop() {
        self.service.client.make(request: Torrents.stopTorrent(id: .id(id)), completion: { (_) in })
    }
}
