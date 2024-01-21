//
//  InternetConnection.swift
//  githubRepo
//
//  Created by Vyacheslav on 31.12.2023.
//

import UIKit
import Reachability

// MARK: -
class InternetConnectionManager {
    
    static let shared = InternetConnectionManager()
    
    public var internetConnection = try! Reachability()
    
    func checkInternetConnection(successHandler: @escaping () -> Void, failureHandler: @escaping () -> Void) {
        try? internetConnection.startNotifier()
        if internetConnection.connection == .wifi || internetConnection.connection == .cellular {
            internetConnection.stopNotifier()
            successHandler()
        } else {
            internetConnection.stopNotifier()
            failureHandler()
        }
    }
}
