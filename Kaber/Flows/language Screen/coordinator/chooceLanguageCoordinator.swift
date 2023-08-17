//
//  chooceLanguageCoordinator.swift
//  Kaber
//
//  Created by Mohamed Ali on 17/08/2023.
//

import UIKit

class chooceLanguageCoordinator: BaseCoordinator {
    let navigationController: UINavigationController
        
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        guard let viewController: languageViewController = declareViewController(screen: .languageViewController) else { return }
        let viewmodel = chooceLanguageViewModel()
        viewmodel.coordinator = self
        viewController.choocelanguageviewmodel = viewmodel
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func goToNewsScreen() {
        let coordinator = newsCoordinator(navigationController: navigationController)
        add(coordinator: coordinator)
        coordinator.start()
    }
}
