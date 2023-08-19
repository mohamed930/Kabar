//
//  constans.swift
//  Kaber
//
//  Created by Mohamed Ali on 16/08/2023.
//

import Foundation

var apiToken = "5ec81ac812b24152afb08e72f1d89f66"

enum Api: String {
    case baseURL = "https://newsapi.org/v2/"
    case allNews = "everything"
}

enum searchKey: String {
    case relevancy
    case popularity
    case publishedAt
}
