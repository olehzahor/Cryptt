//
//  TabBarController.swift
//  Cryptt
//
//  Created by Oleh Zahoriansky on 15.02.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    weak var coordinator: MainCoordinatorProtocol?

    private var tabCoordinators = [Coordinator]()
    
    private func setupAppearance() {
        tabBar.backgroundColor = R.color.grayBg()
        tabBar.unselectedItemTintColor = .gray
    }

    private func setupViewControllers() {
        tabCoordinators.forEach { $0.start() }
        let viewControllers = tabCoordinators.map { $0.navigationController }
        setViewControllers(viewControllers, animated: false)
    }

    private func setupView() {
        setupAppearance()
        setupViewControllers()
    }
        
    init(tabCoordinators: [Coordinator]) {
        super.init(nibName: nil, bundle: nil)
        self.tabCoordinators = tabCoordinators
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
