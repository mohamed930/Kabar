//
//  newsAPI.swift
//  Kaber
//
//  Created by Mohamed Ali on 16/08/2023.
//

import Foundation

protocol newsProtocol {
    func fetchAllArticles(q: String,page: Int,completion: @escaping (Result<newsResponse?,NSError>) -> Void)
}

class newsAPI: BaseAPI<newsNetworking>, newsProtocol {
    
    func fetchAllArticles(q: String,page: Int,completion: @escaping (Result<newsResponse?,NSError>) -> Void) {
        
        fetchData(Target: .fetchAllNews(q: q, language: "en", page: page), ClassName: newsResponse.self) { response in
            completion(response)
        }
    }
}
