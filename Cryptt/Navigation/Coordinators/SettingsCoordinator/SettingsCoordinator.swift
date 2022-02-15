//
//  SettingsCoordinator.swift
//  Cryptt
//
//  Created by Oleh Zahoriansky on 15.02.2022.
//

import UIKit

protocol SettingsCoordinatorProtocol: Coordinator {
    
}

class SettingsCoordinator: SettingsCoordinatorProtocol {
    var navigationController: UINavigationController
    var dependencies: Dependencies

    private let tabBarItem = UITabBarItem(title: R.string.localizable.settingsTitle(),
                                          image: R.image.gear(), tag: 0)

    func start() {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        vc.tabBarItem = tabBarItem
        
        navigationController.pushViewController(vc, animated: false)
    }

    init(navigationController: UINavigationController,
         dependencies: Dependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
}
