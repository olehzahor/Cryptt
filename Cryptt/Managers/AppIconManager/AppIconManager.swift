import UIKit

final class AppIconManager {
    var updateBlock: (() -> Void)?
    
    private let repository = AppIconRepository()
    
    public func getCurrentIcon() -> AppIcon? {
        repository.getAppIcon()
    }
    
    public func getAllIcons() -> [AppIcon] {
        return AppIcon.allCases
    }
    
    public func changeIcon(icon: AppIcon?) {
        guard UIApplication.shared.supportsAlternateIcons else {
            return
        }
        // Change the icon to a specific image with given name
        let choosenIcon = icon
        UIApplication.shared.setAlternateIconName(choosenIcon?.rawValue) { [weak self](error) in
            // After app icon changed, print our error or success message
            if let error = error {
                print("App icon failed to due to \(error.localizedDescription)")
            } else {
                print("App icon changed successfully.")
                guard let icon = icon else {
                    return
                }
                self?.repository.saveIcon(icon: icon)
                self?.updateBlock?()
            }
        }
    }
}

enum AppIcon: String, CaseIterable {
    case whiteIcon = "White"
    case blackIcon = "Black"
    case yellowIcon = "Yellow"
}
