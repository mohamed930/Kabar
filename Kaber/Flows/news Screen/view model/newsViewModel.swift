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
import MOLH

class newsViewModel {
    var coordinator: newsCoordinator!
    let newsapi = newsAPI()
    
    var searchTextFieldBehaviourRelay = BehaviorRelay<String>(value: "")
    
    var placeHolderBehaviourRelay = BehaviorRelay<Bool>(value: true)
    
    var filteredObservable: Observable<Bool> {
        searchTextFieldBehaviourRelay.asObservable().scan(0) { count, text in
            return text.count
        }
        .map { count in
            return (count >= 5 && count % 5 == 0) || (count >= 10 && (count - 10) % 5 == 0)
        }
    }
    
    var searchedIndex = 1
    
    private var SearchednewsBehaviour = BehaviorRelay<[ArticleModel]>(value: [])
    var SearchednewsObervable: Observable<[ArticleModel]> {
        return SearchednewsBehaviour.asObservable()
    }
    
    var pagaignLoadingBehaviour = BehaviorRelay<Bool>(value: false)
    var currentPage: Int = 1
    
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
        
        newsapi.fetchAllArticles(q: "*", page: 1,language: MOLHLanguage.currentAppleLanguage()) { [weak self] response in
            guard let self = self else { return }
            isloadingBehaviour.accept(false)
            
            switch response {
                
            case .success(let model):
                currentPage += 1
                guard let model = model else { return }
                newsBehaviour.accept(model.articles)
                cacheTheArticleOffline()
                
            case .failure(let error):
                print(error.message)
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
           try! realm.write {
               realm.deleteAll()
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
            article.urlToImage      = nil
            
            if let imageUrl = i.urlToImage {
                guard let urlToImage = URL(string: imageUrl) else {
                    article.urlToImage = nil
                    saveToRealm(model: article)
                    return
                }
                
                saveImageToRealm(from: urlToImage) { [weak self] img, error in
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
    
    
    func loadArticlesFromRealmSwiftOperaiton() {
        let storage: RealmSwiftProtocol = RealmSwift()
        
        let articles: [offlineArticleModel] = storage.objects()
        
        var articlesArr = Array<ArticleModel>()
        for i in articles {
            let article = ArticleModel(connection: false,
                                       source: SourceModel(id: "", name: i.source ?? "Unkown"),
                                       author: i.author,
                                       title: i.title,
                                       description: i.artilceDescription,
                                       url: i.url,
                                       urlToImage: "",
                                       urlToImageData: i.urlToImage,
                                       publishedAt: i.publishedAt,
                                       content: i.content)
            
            articlesArr.append(article)
        }
        
        newsBehaviour.accept(articlesArr)
    }
    
    
    func fetchNextPageOperation() {
        pagaignLoadingBehaviour.accept(true)
        
        newsapi.fetchAllArticles(q: "*", page: currentPage,language: MOLHLanguage.currentAppleLanguage()) { [weak self] response in
            guard let self = self else { return }
            pagaignLoadingBehaviour.accept(false)
            
            switch response {
                
            case .success(let model):
                currentPage += 1
                guard let model = model else { return }
                var aricles = newsBehaviour.value
                aricles += model.articles
                
                newsBehaviour.accept(aricles)
                cacheTheArticleOffline()
                
                
            case .failure(let error):
                pagaignLoadingBehaviour.accept(false)
                print(error.message)
            }
        }
    }
    
    
    func clearSearchResult() {
        SearchednewsBehaviour.accept([])
    }
    
    func searchArticleOperation() {
        newsapi.fetchAllArticles(q: searchTextFieldBehaviourRelay.value, page: searchedIndex, language: "") { [weak self] response in
            guard let self = self else { return }
            
            switch response {
                
            case .success(let model):
                guard let model = model else { return }
                
                if model.articles.isEmpty {
                    SearchednewsBehaviour.accept([])
                    placeHolderBehaviourRelay.accept(true)
                }
                else {
                    SearchednewsBehaviour.accept(model.articles)
                    placeHolderBehaviourRelay.accept(false)
                    searchedIndex += 1
                }
                
            case .failure(let error):
                print(error.message)
            }
        }
    }
    
}
