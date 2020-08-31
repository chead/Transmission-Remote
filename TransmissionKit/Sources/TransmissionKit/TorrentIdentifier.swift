//
//  TorrentIdentifier.swift
//  
//
//  Created by 👽 on 8/9/20.
//

import Foundation

public enum TorrentIdentifier {
    case hash(String)
    case id(Int)
}

extension TorrentIdentifier {
    public init(_ string: String) {
        self = .hash(string)
    }

    public init(_ int: Int) {
        self = .id(int)
    }
}

extension TorrentIdentifier: Hashable {}

extension TorrentIdentifier: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .hash(let stringValue):
            try container.encode(stringValue)

        case .id(let numberValue):
            try container.encode(numberValue)
        }
    }
}
