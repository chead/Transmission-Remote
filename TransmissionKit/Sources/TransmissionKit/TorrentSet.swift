//
//  File.swift
//  
//
//  Created by 👽 on 8/9/20.
//

import Foundation

public enum TorrentSet: Encodable {
    case identifiers(Set<TorrentIdentifier>)
    case recentlyActive
    case removed

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .identifiers(let setValue):
            try container.encode(setValue)

        case .recentlyActive:
            try container.encode("recently-active")

        case .removed:
            try container.encode("removed")
        }
    }
}
