//
//  newsCoordinator.swift
//  Kaber
//
//  Created by Mohamed Ali on 15/08/2023.
//

import UIKit

class newsCoordinator: BaseCoordinator {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        guard let viewController: newsViewController = declareViewController(screen: .newsViewController) else { return }
        let viewmodel = newsViewModel()
        viewmodel.coordinator = self
        viewController.newsviewmodel = viewmodel
        navigationController.setViewControllers([viewController], animated: true)
    }
}
