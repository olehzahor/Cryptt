// 
//

import Foundation

protocol SettingsViewModelInterface {
    var delegate: SettingsViewModelDelegate? { get set }
    
    var icons: [String] { get }
    var selectedIcon: String? { get }
    
    func selectIcon(at index: Int)
}

protocol SettingsViewModelDelegate: AnyObject {
    func viewModel(_ viewModel: SettingsViewModelInterface,
                   didUpdateDataSource updateType: TableViewUpdateType)
}

class SettingsViewModel: SettingsViewModelInterface {
    private let iconManager: AppIconManager
    
    weak var delegate: SettingsViewModelDelegate?
    
    var icons: [String]
    var selectedIcon: String?
    
    func selectIcon(at index: Int) {
        iconManager.changeIcon(icon: .init(rawValue: icons[index]))
        selectedIcon = icons[index]
        delegate?.viewModel(self, didUpdateDataSource: .reloadData)
    }

    init(iconManager: AppIconManager) {
        self.iconManager = iconManager
        self.icons = iconManager.getAllIcons().compactMap { $0.rawValue }
        self.selectedIcon = iconManager.getCurrentIcon()?.rawValue
    }
}
