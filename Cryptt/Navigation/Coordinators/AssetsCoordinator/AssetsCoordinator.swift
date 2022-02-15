//
//  AssetsCoordinator.swift
//  Cryptt
//
//  Created by Oleh Zahoriansky on 15.02.2022.
//

import UIKit

protocol AssetsCoordinatorProtocol: Coordinator {
    func showDetails(_ asset: AssetCellDataModel)
}

class AssetsCoordinator: AssetsCoordinatorProtocol {
    var navigationController: UINavigationController
    var dependencies: Dependencies

    private let tabBarItem = UITabBarItem(title: R.string.localizable.assetsTitle(),
                                          image: R.image.bitcoin(), tag: 0)
    
    func start() {
        let viewModel = AssetsListViewModel(assetsManager: dependencies.assetsManager)
        let vc = AssetsListViewController(viewModel: viewModel)
        vc.tabBarItem = tabBarItem
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showDetails(_ asset: AssetCellDataModel) {
        let view = AssetDetailsView()
        let viewModel = AssetDetailsViewModel(watchlistManager: dependencies.watchlistManager,
                                              assetsManager: dependencies.assetsManager,
                                              asset: asset)
        let vc = AssetDetailsViewController(view: view, viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    init(navigationController: UINavigationController,
         dependencies: Dependencies) {
        self.navigationController = navigationController
        navigationController.navigationItem.largeTitleDisplayMode = .automatic
        self.dependencies = dependencies
    }
}
