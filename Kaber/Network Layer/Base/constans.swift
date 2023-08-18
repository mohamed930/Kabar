//
//  constans.swift
//  Kaber
//
//  Created by Mohamed Ali on 16/08/2023.
//

import Foundation

var apiToken = "9a95acef21be4858a910e63a25ca0a5a"

enum Api: String {
    case baseURL = "https://newsapi.org/v2/"
    case allNews = "everything"
}

enum searchKey: String {
    case relevancy
    case popularity
    case publishedAt
}
