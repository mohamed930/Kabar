//
//  DataRequest.swift
//  Kaber
//
//  Created by Mohamed Ali on 18/08/2023.
//

import Foundation
import Alamofire

// Custom response serializer for handling success and error models
extension DataRequest {
    @discardableResult
    func responseSuccessAndErrorDecodables<T: Decodable, M: Decodable>(
        successType: T.Type = T.self,
        errorType: M.Type = M.self,
        queue: DispatchQueue = .main,
        completionHandler: @escaping (Result<T, M>) -> Void
    ) -> Self {
        return responseDecodable(of: T.self, queue: queue) { response in
            
            guard let theJSONData =  response.data else { return }
            
            if let string = String(data: theJSONData, encoding: .utf8) {
               print(string) // Prints the string representation of the data
            }
            
            switch response.result {
            case .success(let value):
                completionHandler(.success(value))
            case .failure(let error):
                do {
                    if let data = response.data {
                        let errorModel = try JSONDecoder().decode(M.self, from: data)
                        completionHandler(.failure(errorModel))
                    } else {
                        // Error decoding error model or no data, handle as needed
                        completionHandler(.failure(error as! M))
                    }
                } catch {
                    // Error decoding error model, handle as needed
                    completionHandler(.failure(error as! M))
                }
            }
        }
    }
}
