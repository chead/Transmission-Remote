//
//  TransmissionTorrent.swift
//  Transmission Remote
//
//  Created by 👽 on 8/31/20.
//  Copyright © 2020 chead. All rights reserved.
//

import Foundation
import CoreData

@objc(TransmissionTorrent)

public class TransmissionTorrent: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var finished: Bool
    @NSManaged var service: TransmissionService
}
