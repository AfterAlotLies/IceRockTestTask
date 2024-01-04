//
//  InternetConnection.swift
//  githubRepo
//
//  Created by Vyacheslav on 31.12.2023.
//

import UIKit
import Reachability

final class InternetConnection {
    static let shared = InternetConnection()
    private init() {}
    public var internetConnection = try! Reachability()
}
