//
//  newsDetailsCoordinator.swift
//  Kaber
//
//  Created by Mohamed Ali on 17/08/2023.
//

import UIKit

class newsDetailsCoordinator : BaseCoordinator {
    let navigationController: UINavigationController
    var article: ArticleModel
    
    init(navigationController: UINavigationController,article: ArticleModel) {
        self.navigationController = navigationController
        self.article = article
    }
    
    override func start() {
        guard let viewController: newsDetailsViewController = declareViewController(screen: .newsDetailsViewController) else { return }
        let viewmodel = newsDetailsViewModel()
        viewmodel.coordinator = self
        viewmodel.articleBehaviour.accept(article)
        viewController.newsdetailsviewmodel = viewmodel
        navigationController.pushViewController(viewController, animated: true)
    }
}
