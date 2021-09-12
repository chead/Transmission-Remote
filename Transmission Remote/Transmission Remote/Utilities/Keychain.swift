//
//  Keychain.swift
//  Transmission Remote
//
//  Created by 👽 on 9/4/20.
//  Copyright © 2020 chead. All rights reserved.
//

import Foundation
import Security

// Via https://stackoverflow.com/a/37539998/10913592

class Keychain {
    class func delete(key: String) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key ] as [String : Any]

        return SecItemDelete(query as CFDictionary)
    }

    class func update(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key ] as [String : Any]

        return SecItemUpdate(query as CFDictionary, [kSecValueData: data] as CFDictionary)
    }

    class func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]

        let deleteStatus = Keychain.delete(key: key)

        guard deleteStatus == errSecSuccess || deleteStatus == errSecItemNotFound else { return deleteStatus }

        return SecItemAdd(query as CFDictionary, nil)
    }

    class func load(key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]

        var dataTypeRef: AnyObject? = nil

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }
}
