//
//  TransmissionFile.swift
//  Transmission Remote
//
//  Created by 👽 on 8/29/21.
//  Copyright © 2021 chead. All rights reserved.
//

import Foundation
import CoreData
import TransmissionKit

@objc(TransmissionFile)

public class TransmissionFile: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var size: Int
    @NSManaged var progress: Float
    @NSManaged var torrent: TransmissionTorrent

    convenience init(file: Torrent.File, torrent: TransmissionTorrent, managedObjectContext: NSManagedObjectContext) {
        guard let transmissionFileEntity = NSEntityDescription.entity(forEntityName: "TransmissionFile", in: managedObjectContext)
        else { fatalError("Failed to initialize NSEntityDescription: TransmissionTorrent") }

        self.init(entity: transmissionFileEntity, insertInto: managedObjectContext)

        self.name = file.name
        self.size = file.length
        self.progress = Float(file.bytesCompleted)/Float(file.length)

        self.torrent = torrent
    }
}
