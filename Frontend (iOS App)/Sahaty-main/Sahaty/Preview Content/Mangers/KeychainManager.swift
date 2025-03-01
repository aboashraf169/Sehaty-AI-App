//
//  KeychainManager.swift
//  Sahaty
//
//  Created by mido mj on 1/14/25.
//


import Security
import Foundation

class KeychainManager {
    static let shared = KeychainManager()

    func saveToken(_ token: String, forKey key: String = "BearerToken") -> Bool {
        guard let data = token.data(using: .utf8) else { return false }
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query) // حذف العنصر الحالي إذا كان موجودًا
        let status = SecItemAdd(query, nil)
        return status == errSecSuccess
    }

    func getToken(forKey key: String = "BearerToken") -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)

        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    func deleteToken(forKey key: String = "BearerToken") -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary

        let status = SecItemDelete(query)
        if status == errSecSuccess {
            print("Token deleted successfully from Keychain.")
            return true
        } else if status == errSecItemNotFound {
            print("Token not found in Keychain.")
            return false
        } else {
            print("Failed to delete token. Status code: \(status)")
            return false
        }

    }
    
    func isTokenAvailable(forKey key: String) -> Bool {
        guard let token = getToken(forKey: key) else {
            return false
        }
        return !token.isEmpty
    }
}
