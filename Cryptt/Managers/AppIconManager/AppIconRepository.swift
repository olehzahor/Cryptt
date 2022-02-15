//
//  AppIconRepository.swift
//  Cryptt
//
//  Created by Oleh Zahoriansky on 15.02.2022.
//

import Foundation

final class AppIconRepository {
    private let appIconKey = "cryptt_app_icon"
    
    private let defaults = UserDefaults.standard
    
    func saveIcon(icon: AppIcon) {
        let name = icon.rawValue
        defaults.setValue(name, forKey: appIconKey)
    }
    
    func getAppIcon() -> AppIcon {
        guard let name = defaults.string(forKey: appIconKey) else {
            return .yellowIcon
        }
        guard let appIcon = AppIcon(rawValue: name) else {
            return .yellowIcon
        }
        return appIcon
    }
}
