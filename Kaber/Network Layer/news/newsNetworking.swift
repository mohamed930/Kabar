//
//  newsNetworking.swift
//  Kaber
//
//  Created by Mohamed Ali on 16/08/2023.
//

import Foundation
import Alamofire

enum newsNetworking {
    case fetchAllNews(q: String,language: String, sortBy: searchKey = .publishedAt,pageSize: Int = 25 ,page: Int)
}

extension newsNetworking: TargetType {
    var baseURL: Api {
        return .baseURL
    }
    
    var path: Api {
        return .allNews
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: Task {
        switch self {
        case .fetchAllNews(let q,let language, let sortBy,let pageSize,let page):
            let params = [
                            "q": q,
                            "language": language,
                            "sortBy": sortBy.rawValue,
                            "pageSize": pageSize,
                            "page": page
                         ] as [String: Any]
            print(params)
            
            return .requestParameters(parameters: params, encoding: URLEncoding(destination: .queryString))
        }
    }
    
    var headers: [String : String]? {
        return ["Authorization":"Bearer \(apiToken)"]
    }
    
    
}
