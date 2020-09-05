//
//  Credentials.swift
//  
//
//  Created by 👽 on 9/4/20.
//

import Foundation

public struct Credentials: Codable {
    public let username: String
    public let password: String

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
