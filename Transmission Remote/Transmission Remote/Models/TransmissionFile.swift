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

public struct TransmissionFile: Hashable {
    var name: String
    var size: Int
    var progress: Float

    init(file: Torrent.File) {
        self.name = file.name
        self.size = file.length
        self.progress = Float(file.bytesCompleted)/Float(file.length)
    }
}
