//
//  newsAPI.swift
//  Kaber
//
//  Created by Mohamed Ali on 16/08/2023.
//

import Foundation
import MOLH

protocol newsProtocol {
    func fetchAllArticles(q: String,page: Int,completion: @escaping (Result<newsResponse?,NSError>) -> Void)
}

class newsAPI: BaseAPI<newsNetworking>, newsProtocol {
        
    private var appLanguage: String!
    
    override init() {
        let localStorage: LocalStorageProtocol = LocalStorage()
        guard let lang: [String] = localStorage.value(key: LocalStorageKeys.AppleLanguages) else { return }
        guard var pickedLang = lang.first else { return }
        pickedLang = pickedLang.components(separatedBy: "-")[0]
        appLanguage = pickedLang
    }
    
    func fetchAllArticles(q: String,page: Int,completion: @escaping (Result<newsResponse?,NSError>) -> Void) {
        
        fetchData(Target: .fetchAllNews(q: q, language: appLanguage , page: page), ClassName: newsResponse.self) { response in
            completion(response)
        }
    }
}
