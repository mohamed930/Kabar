//
//  offlineArticleModel.swift
//  Kaber
//
//  Created by Mohamed Ali on 17/08/2023.
//

import Foundation
import RealmSwift

class offlineArticleModel: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var source: String? = ""
    @objc dynamic var author: String? = ""
    @objc dynamic var title: String = ""
    @objc dynamic var artilceDescription: String? = ""
    @objc dynamic var url: String = ""
    @objc dynamic var urlToImage: Data?
    @objc dynamic var publishedAt: String = ""
    @objc dynamic var content: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
