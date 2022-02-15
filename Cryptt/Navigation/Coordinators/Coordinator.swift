//
//  Coordinator.swift
//  Cryptt
//
//  Created by Oleh Zahoriansky on 15.02.2022.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}
