//
//  keyValueStorage.swift
//  githubRepo
//
//  Created by Vyacheslav on 26.12.2023.
//

import UIKit

class KeyValueStorage {
    
    static let shared = KeyValueStorage()
    
    var authToken: String? {
        return UserDefaults.standard.string(forKey: "authToken")
    }
    
    var reposUrl: String? {
        return UserDefaults.standard.string(forKey: "reposUrl")
    }
    
    func saveAuthToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: "authToken")
    }
    
    func saveReposUrl(url: String) {
        UserDefaults.standard.setValue(url, forKey: "reposUrl")
    }
    
    func deleteAuthToken() {
        UserDefaults.standard.removeObject(forKey: "authToken")
    }
    
    func deleteReposUrl() {
        UserDefaults.standard.removeObject(forKey: "reposUrl")
    }
}
