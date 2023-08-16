//
//  BaseAPI.swift
//  store
//
//  Created by Mohamed Ali on 24/07/2023.
//

import Foundation
import Alamofire

class BaseAPI<T:TargetType> {
    
    func fetchData<M:Codable>(Target:T, ClassName:M.Type, completion: @escaping (Result<M?,NSError>) -> ()) {
        
        let method = Alamofire.HTTPMethod(rawValue: Target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(Target.headers ?? [:])
        let params = buildParams(task: Target.task)
        
        // Create a URLRequest with the desired URL and timeout interval
        var urlRequest = URLRequest(url: URL(string: Target.baseURL.rawValue + Target.path.rawValue)!)
        urlRequest.timeoutInterval = 30/60
        
        urlRequest.method = method
        urlRequest.headers = headers
        
        print(urlRequest)
        
        AF.request(urlRequest.url!, method: method, parameters: params.0,encoding: params.1,headers: headers).responseDecodable(of: M.self) { response in
            
            switch response.result {
                
            case .success(_):
                guard let theJSONData =  response.data else {
                    // ADD Custom Error
                    let error = NSError(domain: Target.baseURL.rawValue, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message1])
                    completion(.failure(error))
                    return
                }
                
                if let string = String(data: theJSONData, encoding: .utf8) {
                   print(string) // Prints the string representation of the data
                }
                
                guard let response = try? response.result.get() else {
                    let error = NSError(domain: Target.baseURL.rawValue, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message1])
                    completion(.failure(error))
                    
                    return
                }
                
                completion(.success(response))
                
            case .failure(let e):
                if e.isSessionTaskError,
                   let urlError = e.underlyingError as? URLError,
                   urlError.code == .timedOut {
                    // Handle timeout error
                    let error = NSError(domain: Target.baseURL.rawValue, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message2])
                    completion(.failure(error))
                } else {
                    // Handle other errors
                    let error = NSError(domain: Target.baseURL.rawValue, code: 0, userInfo: [NSLocalizedDescriptionKey: e.localizedDescription])
                    completion(.failure(error))
                }
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
