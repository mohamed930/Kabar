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
    
    private var newsBehaviour = BehaviorRelay<[ArticleModel]>(value: [])
    var newsObservable: Observable<[ArticleModel]> {
        return newsBehaviour.asObservable()
    }
    
    
    func fetchNewsOperation() {
        let arr = [
                    ArticleModel(source: SourceModel(id: "1", name: "marca"),
                                 author: "marca.com",
                                 title: "The impact of the largest asteroid ever to hit Earth revealed",
                                 description: "The impact of the largest asteroid ever to hit Earth revealedThe impact of the largest asteroid ever to hit Earth revealedThe impact of the largest asteroid ever to hit Earth revealed",
                                 url: "https://www.marca.com/en/lifestyle/world-news/2023/08/14/64da9174268e3e081f8b45ae.html",
                                 urlToImage: "https://phantom-marca.unidadeditorial.es/70668632aff754729cabf9cc6e8dad2d/resize/1200/f/jpg/assets/multimedia/imagenes/2023/08/14/16920448140373.jpg",
                                 publishedAt: dateFromString("2023-08-14T21:20:39Z"),
                                 content: "A structure discovered in Australia is said to be the result of the largest asteroid impact in Earth's history."),
                    ArticleModel(source: SourceModel(id: "1", name: "marca"),
                                 author: "marca.com",
                                 title: "The impact of the largest asteroid ever to hit Earth revealed",
                                 description: "The impact of the largest asteroid ever to hit Earth revealedThe impact of the largest asteroid ever to hit Earth revealedThe impact of the largest asteroid ever to hit Earth revealed",
                                 url: "https://www.marca.com/en/lifestyle/world-news/2023/08/14/64da9174268e3e081f8b45ae.html",
                                 urlToImage: "https://www.tubefilter.com/wp-content/uploads/2023/08/fresh-cut-gaming-clips.jpg",
                                 publishedAt: dateFromString("2023-08-14T21:20:27Z"),
                                 content: "A structure discovered in Australia is said to be the result of the largest asteroid impact in Earth's history."),
                    ArticleModel(source: SourceModel(id: "1", name: "marca"),
                                 author: "marca.com",
                                 title: "The impact of the largest asteroid ever to hit Earth revealed",
                                 description: "The impact of the largest asteroid ever to hit Earth revealedThe impact of the largest asteroid ever to hit Earth revealedThe impact of the largest asteroid ever to hit Earth revealed",
                                 url: "https://www.marca.com/en/lifestyle/world-news/2023/08/14/64da9174268e3e081f8b45ae.html",
                                 urlToImage: "https://media.zenfs.com/en/afp.com/29b740cbef92c052528856b389da6b85",
                                 publishedAt: dateFromString("2023-08-14T21:20:39Z"),
                                 content: "A structure discovered in Australia is said to be the result of the largest asteroid impact in Earth's history.")
                  ]
        
        newsBehaviour.accept(arr)
    }
    
    
    private func dateFromString(_ isoDate: String) -> Date{
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from:isoDate)!
        
        return date
    }
}
