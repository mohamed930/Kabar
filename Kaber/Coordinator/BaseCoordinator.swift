//
//  BaseCoordinator.swift
//  LNJ
//
//  Created by Mohamed Ali on 02/05/2023.
//

import UIKit

class BaseCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    var parantCoordinator: BaseCoordinator?
    
    func start() {
        fatalError("Children shoud implement 'start'")
    }
    
    func removeFromParant() {
        parantCoordinator?.remove(coordinator: self)
    }
    
    
    func declareViewController<T: UIViewController>(screen: screens) -> T? {
        return T(nibName: screen.rawValue, bundle: nil)
    }
}
