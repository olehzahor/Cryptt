// 
//

import UIKit

class SettingsViewController: UIViewController {
    private var viewModel: SettingsViewModelInterface
    
    private lazy var tableUpdater = TableUpdater(tableView)
    private let tableView = UITableView {
        $0.backgroundColor = .white
        $0.register(UITableViewCell.self)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupView() {
        viewModel.delegate = self
        setupTableView()
        
        title = R.string.localizable.settingsTitle()
        view.backgroundColor = .white
    }

    public init(viewModel: SettingsViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsViewController: SettingsViewModelDelegate {
    func viewModel(_ viewModel: SettingsViewModelInterface, didUpdateDataSource updateType: TableViewUpdateType) {
        tableUpdater.update(actions: [updateType])
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.icons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UITableViewCell.self, indexPath: indexPath)
        let icon = viewModel.icons[indexPath.row]
        cell.textLabel?.text = icon
        cell.accessoryType = viewModel.selectedIcon == icon ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Icon"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectIcon(at: indexPath.row)
    }
}
