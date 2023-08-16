//
//  TargetType.swift
//  store
//
//  Created by Mohamed Ali on 24/07/2023.
//

import Foundation

import Alamofire


enum HTTPMethod : String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum Task {
    case requestPlain
    case requestParameters(parameters : [String:Any] , encoding: ParameterEncoding)
}

protocol TargetType {
    var baseURL: Api { get }
    var path: Api { get }
    var method: HTTPMethod { get }
    var task: Task { get }
    var headers: [String:String]? { get }
}
