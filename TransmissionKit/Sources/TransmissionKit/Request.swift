//
//  Request.swift
//  
//
//  Created by 👽 on 5/17/20.
//

import Foundation

public struct Request<Arguments: Encodable, Model>: Encodable {
    public let method: String
    public let arguments: Arguments
    public let tag: Int

    init(method: String, arguments: Arguments, tag: Int) {
        self.method = method
        self.arguments = arguments
        self.tag = tag
    }

    init(method: String, arguments: Arguments) {
        self.init(method: method, arguments: arguments, tag: Int.random(in: Int.min...Int.max))
    }
}
