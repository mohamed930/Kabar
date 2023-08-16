//
//  newsViewModel.swift
//  Kaber
//
//  Created by Mohamed Ali on 15/08/2023.
//

import Foundation
import RxSwift
import RxCocoa

class newsViewModel {
    var coordinator: newsCoordinator!
    let newsapi = newsAPI()
    
    var isloadingBehaviour = BehaviorRelay<Bool>(value: false)
    
    private var newsBehaviour = BehaviorRelay<[ArticleModel]>(value: [])
    var newsObservable: Observable<[ArticleModel]> {
        return newsBehaviour.asObservable()
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
                
            case .failure(let error):
                let e = error.userInfo[NSLocalizedDescriptionKey] as? String ?? ""
                print(e)
            }
        }
    }
}
