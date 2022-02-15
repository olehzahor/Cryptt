//
//  AppDelegate.swift
//  Cryptt
//
//  Created by Oleh Zahoriansky on 15.02.2022.
//

import UIKit
import SnapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var mainCoordinator: MainCoordinatorProtocol?
    var dependencies: Dependencies?

    var window: UIWindow?
    
    func setupAppearance() {
        
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let dependencies = Dependencies()
        let navigationController = UINavigationController()
        let coordinator = MainCoordinator(navigationController: navigationController, dependencies: dependencies)
        mainCoordinator = coordinator
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        mainCoordinator?.start()
        setupAppearance()
        window?.makeKeyAndVisible()
        
        self.dependencies = dependencies

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }
}
