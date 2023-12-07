//
//  AppRepository.swift
//  githubRepo
//
//  Created by Vyacheslav on 04.12.2023.
//

import UIKit
import Alamofire

class AppRepository {
    
    private var urlResponse = ""
    
    func set(url: String?) {
        guard let url = url else { return }
        urlResponse = url
    }
    
    func getRepositories(completion: @escaping(Array<Repo>?, Error?) -> Void) {
        AF.request(urlResponse, method: .get).validate().responseDecodable(of: [Repo].self) { response in
            switch response.result {
            case .success(let data):
                let limitedCountOfRepositories = Array(data.prefix(10))
                completion(limitedCountOfRepositories, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func signIn(token: String, completion: @escaping (UserInfo?, Error?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        let url = "https://api.github.com/user"
        
        AF.request(url, headers: headers).validate().responseDecodable(of: UserInfo.self) { response in
            switch response.result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    static let shared = AppRepository()
    private init() {}
}
