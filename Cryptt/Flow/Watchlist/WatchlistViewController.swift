// 
//

import UIKit

class WatchlistViewController: UIViewController {
    weak var coordinator: WatchlistCoordinatorProtocol?
    
    private var viewModel: WatchlistViewModelInterface
    
    private let tableView = UITableView {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.register(AssetCell.self)
    }
    
    private lazy var tableUpdater = TableUpdater(tableView)
    private let refreshControl = UIRefreshControl()
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel.fetchData()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func setupView() {
        viewModel.delegate = self
        view.backgroundColor = .white
        
        setupTableView()
        title = R.string.localizable.watchlistTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchData()
    }
    
    public init(viewModel: WatchlistViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WatchlistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.assetsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(AssetCell.self, indexPath: indexPath)
        cell.setData(viewModel.getAssetModel(forCellAt: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeItem(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showDetails(viewModel.getAssetModel(forCellAt: indexPath.row))
    }
}

extension WatchlistViewController: WatchlistViewModelDelegate {
    func viewModel(_ viewModel: WatchlistViewModelInterface, didUpdateDataSource updateType: TableViewUpdateType) {
        refreshControl.endRefreshing()
        if isViewLoaded, self.view.window != nil {
            tableUpdater.update(actions: [updateType])
        }
    }
    
    func viewModel(_ viewModel: WatchlistViewModelInterface, didFailWithError message: String) {
        refreshControl.endRefreshing()
        showFailedAlert(message: message)
    }
}
