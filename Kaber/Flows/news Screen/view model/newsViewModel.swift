//
//  newsViewModel.swift
//  Kaber
//
//  Created by Mohamed Ali on 15/08/2023.
//

import Foundation
import RxSwift
import RxCocoa
import Kingfisher

class newsViewModel {
    var coordinator: newsCoordinator!
    let newsapi = newsAPI()
    
    var isloadingBehaviour = BehaviorRelay<Bool>(value: false)
    
    private var newsBehaviour = BehaviorRelay<[ArticleModel]>(value: [])
    var newsObservable: Observable<[ArticleModel]> {
        return newsBehaviour.asObservable()
    }
    
    func moveToNewsDetailsOperation(article: ArticleModel) {
        coordinator.moveToArticleDetails(article: article)
    }
    
    func fetchNewsOperation() {
        isloadingBehaviour.accept(true)
        
        newsapi.fetchAllArticles(q: "*", page: 1) { [weak self] response in
            guard let self = self else { return }
            isloadingBehaviour.accept(false)
            
            switch response {
                
            case .success(let model):
                guard let model = model else { return }
                newsBehaviour.accept(model.articles)
                cacheTheArticleOffline()
                
            case .failure(let error):
                let e = error.userInfo[NSLocalizedDescriptionKey] as? String ?? ""
                print(e)
            }
        }
    }
    
    private func cacheTheArticleOffline() {
        let realmObj = RealmSwift()
        print(realmObj.realmFileLocation)
        
        guard let realm = realmObj.realm else { return }
        
        let exsistingArticles = realm.objects(offlineArticleModel.self).sorted(byKeyPath: "publishedAt", ascending: true)
        let existingArticleCount = exsistingArticles.count
        
        // If there are already 50 articles, delete the oldest ones
       if existingArticleCount >= 50 {
           let articlesToDelete = Array(exsistingArticles.prefix(existingArticleCount - 49)) // Keep the latest 49 articles
           try! realm.write {
               realm.delete(articlesToDelete)
           }
       }
        
        for i in newsBehaviour.value {
            let article = offlineArticleModel()
            article.id                  = UUID().uuidString
            article.source              = i.source.name
            article.author              = i.author
            article.title               = i.title
            article.artilceDescription  = i.description
            article.url                 = i.url
            article.publishedAt         = i.publishedAt
            article.content             = i.content
            
            if let imageUrl = i.urlToImage {
                saveImageToRealm(from: URL(string: imageUrl)!) { [weak self] img, error in
                    guard let self = self else { return }
                    if let img = img {
                        article.urlToImage  = img
                        saveToRealm(model: article)
                    }
                }
            }
        }
    }
    
    private func saveToRealm(model: offlineArticleModel) {
        let storage: RealmSwiftProtocol = RealmSwift()
        storage.write(model)
    }
    
    // Inside your function or code block
    private func saveImageToRealm(from url: URL, completion: @escaping (Data?,Error?) -> ()) {
        // Use Kingfisher to download the image
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                let image = value.image
                
                // Convert UIImage to NSData
                if let imageData = image.jpegData(compressionQuality: 0.8) {
                    completion(imageData,nil)
                }
                
            case .failure(let error):
                completion(nil,error)
                break
            }
        }
    }
}
