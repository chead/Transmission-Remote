//
//  TransmissionCredentials.swift
//  Transmission Remote
//
//  Created by 👽 on 8/31/21.
//  Copyright © 2021 chead. All rights reserved.
//

import Foundation
import TransmissionKit

struct TransmissionCredentials {
    let username: String
    let password: String

    static func addCredentials(credentials: TransmissionCredentials, uuid: UUID) -> Bool {
        let credentials = TransmissionKit.Credentials(username: credentials.username, password: credentials.password)
        var status: OSStatus = 0

        do {
            let credentialsData = try JSONEncoder().encode(credentials)

            status = Keychain.save(key: uuid.uuidString, data: credentialsData)
        } catch {}

        return status == 0 ? true : false
    }

    static func getCredentials(uuid: UUID) -> TransmissionCredentials? {
        var credentials: TransmissionKit.Credentials?

        if let keychainData = Keychain.load(key: uuid.uuidString) {
            do {
                credentials = try JSONDecoder().decode(Credentials.self, from: keychainData)
            } catch {}
        }

        if let credentials = credentials {
            return TransmissionCredentials(username: credentials.username, password: credentials.password)
        }

        return nil
    }

    static func updateCredentials(credentials: TransmissionCredentials, uuid: UUID) -> Bool {
        let credentials = TransmissionKit.Credentials(username: credentials.username, password: credentials.password)
        var status: OSStatus = 0

        do {
            let credentialsData = try JSONEncoder().encode(credentials)

            status = Keychain.update(key: uuid.uuidString, data: credentialsData)
        } catch {}

        return status == 0 ? true : false
    }

    static func deleteCredentials(uuid: UUID) -> Bool {
        return Keychain.delete(key: uuid.uuidString) == 0 ? true : false
    }
}
