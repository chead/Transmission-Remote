//
//  Response.swift
//  
//
//  Created by 👽 on 5/17/20.
//

import Foundation

public struct Response<Model: Decodable>: Decodable {
    public let arguments: Model
    public let result: Result
    public let tag: Int
}

extension Response {
    public enum Result: Decodable {
        public typealias RawValue = String

        case success
        case failure(String)
    }
}

extension Response.Result: RawRepresentable {
    public init(rawValue: String) {
        self = {
            switch rawValue {
            case "success":
                return .success

            default:
                return .failure(rawValue)
            }
        }()
    }

    public var rawValue: String {
        switch self {
        case .success:
            return "success"

        case .failure(let string):
            return string
        }
    }
}
