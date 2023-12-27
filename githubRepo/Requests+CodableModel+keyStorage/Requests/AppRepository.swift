//
//  AppRepository.swift
//  githubRepo
//
//  Created by Vyacheslav on 04.12.2023.
//

import UIKit
import Alamofire

class AppRepository {
    
    private var authUrl = ""
    
    func setAuthUrl(url: String?) {
        guard let url = url else { return }
        authUrl = url
    }
    
    func getRepositories(completion: @escaping(Array<Repo>?, Error?) -> Void) {
        
        let keyValue = KeyValueStorage.shared
        
        if let url = keyValue.reposUrl, !url.isEmpty {
            AF.request(url, method: .get).validate().responseDecodable(of: [Repo].self) { response in
                switch response.result {
                case .success(let data):
                    let limitedCountOfRepositories = Array(data.prefix(10))
                    completion(limitedCountOfRepositories, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        } else {
            AF.request(authUrl, method: .get).validate().responseDecodable(of: [Repo].self) { response in
                switch response.result {
                case .success(let data):
                    let limitedCountOfRepositories = Array(data.prefix(10))
                    completion(limitedCountOfRepositories, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    func getRepository(repoId: String, completion: @escaping (RepoDetails?, Error?) -> Void) {
        let repoUrl = "https://api.github.com/repositories/\(repoId)"
        
        AF.request(repoUrl, method: .get).validate().responseDecodable(of: RepoDetails.self) { response in
            switch response.result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getRepositoryReadme(ownerName: String, repositoryName: String, branchName: String, completion: @escaping (String?, Error?) -> Void) {
        let readmeUrl = "https://raw.githubusercontent.com/icerockdev/moko-resources/master/README.md"
        
        AF.request(readmeUrl, method: .get).validate().responseString { response in
            switch response.result {
            case .success(let data):
                completion(data, nil)
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
        
        AF.request(url, method: .get, headers: headers).validate().responseDecodable(of: UserInfo.self) { response in
            switch response.result {
            case .success(let data):
                completion(data, nil)
                KeyValueStorage.shared.saveAuthToken(token: token)
                KeyValueStorage.shared.saveReposUrl(url: data.urlRepositories)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    static let shared = AppRepository()
    private init() {}
}
