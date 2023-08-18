//
//  newsAPI.swift
//  Kaber
//
//  Created by Mohamed Ali on 16/08/2023.
//

import Foundation
import MOLH

protocol newsProtocol {
    func fetchAllArticles(q: String,page: Int,completion: @escaping (Result<newsResponse?,errorResponse>) -> Void)
}

class newsAPI: BaseAPI<newsNetworking>, newsProtocol {
    
    func fetchAllArticles(q: String,page: Int,completion: @escaping (Result<newsResponse?,errorResponse>) -> Void) {
        
        fetchData(Target: .fetchAllNews(q: q, language: MOLHLanguage.currentAppleLanguage() , page: page), ClassName: newsResponse.self) { response in
            completion(response)
        }
    }
}
