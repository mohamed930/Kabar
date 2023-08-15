//
//  AppCoordinator.swift
//  LNJ
//
//  Created by Mohamed Ali on 02/05/2023.
//

import UIKit


final class AppCoordinator: BaseCoordinator {
    
    private let window: UIWindow?
        
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        let navigationController = UINavigationController()
        
        let coordinator = newsCoordinator(navigationController: navigationController)
        add(coordinator: coordinator)
        coordinator.start()
        
        guard let window = window else {
            return
        }

        navigationController.isNavigationBarHidden = true
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
