//
//  BaseAPI.swift
//  store
//
//  Created by Mohamed Ali on 24/07/2023.
//

import Foundation
import Alamofire

class BaseAPI<T:TargetType> {
    
    func fetchData<M:Codable>(Target:T, ClassName:M.Type, completion: @escaping (Result<M?,errorResponse>) -> ()) {
        
        let method = Alamofire.HTTPMethod(rawValue: Target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(Target.headers ?? [:])
        let params = buildParams(task: Target.task)
        
        // Create a URLRequest with the desired URL and timeout interval
        var urlRequest = URLRequest(url: URL(string: Target.baseURL.rawValue + Target.path.rawValue)!)
        urlRequest.timeoutInterval = 30/60
        
        urlRequest.method = method
        urlRequest.headers = headers
        
        print(urlRequest)
        
        AF.request(urlRequest.url!, method: method, parameters: params.0,encoding: params.1,headers: headers).responseSuccessAndErrorDecodables(successType: M.self, errorType: errorResponse.self) { response in
            switch response {
               case .success(let successModel):
                   // Handle success model
                    completion(.success(successModel))
                case .failure(let e):
                completion(.failure(e))
                
            }
        }
    }
    
    private func buildParams(task: Task) -> ([String:Any], ParameterEncoding) {
        switch task {
        case .requestPlain:
            return ([:] , URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters,encoding)
        }
    }
    
}
