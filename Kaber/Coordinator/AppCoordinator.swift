//
//  AppCoordinator.swift
//  LNJ
//
//  Created by Mohamed Ali on 02/05/2023.
//

import UIKit


final class AppCoordinator: BaseCoordinator {
    
    private let window: UIWindow?
    
    static let shared = AppCoordinator()
        
    init(window: UIWindow) {
        self.window = window
    }
    
    override init() {
        self.window = nil
    }
    
    override func start() {
        let navigationController = UINavigationController()
        
        let local: LocalStorage = LocalStorage()
        let user: Bool? = local.value(key: LocalStorageKeys.firstTime)
        
        
        if  user == nil {
            let coordinator = chooceLanguageCoordinator(navigationController: navigationController)
            add(coordinator: coordinator)
            coordinator.start()
        }
        else {
            let coordinator = newsCoordinator(navigationController: navigationController)
            add(coordinator: coordinator)
            coordinator.start()
        }
        
        guard let window = window else {
            return
        }

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
    }
    
    func restart() {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let navigationController = window?.rootViewController as! UINavigationController
        
        let coordinator = newsCoordinator(navigationController: navigationController)
        add(coordinator: coordinator)
        coordinator.start()
    }
}
