//
//  MainCoordinator.swift
//  Cryptt
//
//  Created by Oleh Zahoriansky on 15.02.2022.
//

import UIKit

protocol MainCoordinatorProtocol: Coordinator {
    
}

class MainCoordinator: MainCoordinatorProtocol {
    var navigationController: UINavigationController
    var dependencies: Dependencies

    func start() {
        let coordinators: [Coordinator] = [
            AssetsCoordinator(navigationController: .init(), dependencies: dependencies),
            WatchlistCoordinator(navigationController: .init(), dependencies: dependencies),
            SettingsCoordinator(navigationController: .init(), dependencies: dependencies)
        ]
        let vc = MainTabBarController(tabCoordinators: coordinators)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    init(navigationController: UINavigationController,
         dependencies: Dependencies) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
        self.dependencies = dependencies
    }
}
