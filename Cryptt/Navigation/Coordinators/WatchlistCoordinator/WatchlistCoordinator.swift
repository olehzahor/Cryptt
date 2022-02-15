//
//  WatchlistCoordinator.swift
//  Cryptt
//
//  Created by Oleh Zahoriansky on 15.02.2022.
//

import UIKit

protocol WatchlistCoordinatorProtocol: Coordinator {
    func showDetails(_ asset: AssetCellDataModel)
}

class WatchlistCoordinator: WatchlistCoordinatorProtocol {
    var navigationController: UINavigationController
    var dependencies: Dependencies
    
    private var assetsCoordinator: AssetsCoordinatorProtocol
    
    private let tabBarItem = UITabBarItem(title: R.string.localizable.watchlistTitle(),
                                          image: R.image.heartFill(), tag: 0)

    func start() {
        let viewModel = WatchlistViewModel(watchlistManager: dependencies.watchlistManager,
                                           assetsManager: dependencies.assetsManager)
        let vc = WatchlistViewController(viewModel: viewModel)
        vc.tabBarItem = tabBarItem
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showDetails(_ asset: AssetCellDataModel) {
        assetsCoordinator.showDetails(asset)
    }
    
    init(navigationController: UINavigationController,
         dependencies: Dependencies) {
        self.navigationController = navigationController
        self.assetsCoordinator = AssetsCoordinator(navigationController: navigationController,
                                                   dependencies: dependencies)
        self.dependencies = dependencies
    }
}
