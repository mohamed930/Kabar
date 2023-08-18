//
//  errorResponse.swift
//  Kaber
//
//  Created by Mohamed Ali on 18/08/2023.
//

import Foundation

struct errorResponse: Error , Decodable {
    let status: String
    let code: String
    let message: String
}
