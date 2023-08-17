//
//  newsDetailsViewModel.swift
//  Kaber
//
//  Created by Mohamed Ali on 17/08/2023.
//

import Foundation
import RxSwift
import RxCocoa

class newsDetailsViewModel {
    var coordinator: newsDetailsCoordinator!
    
    var articleBehaviour = BehaviorRelay<ArticleModel?>(value: nil)
    
    func showShareSheet(ob: UIViewController) {
        guard let article = articleBehaviour.value else { return }
        let url = article.url
        
        let shareActionSheet = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        ob.present(shareActionSheet, animated: true)
    }
}
