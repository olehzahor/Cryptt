// 
//

import UIKit

class AssetsListViewController: UIViewController {
    weak var coordinator: AssetsCoordinatorProtocol?
    
    private var viewModel: AssetsListViewModelInterface
    
    private var searchController: UISearchController?
    
    private let refreshControl = UIRefreshControl()

    private let tableView = UITableView {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.register(AssetCell.self)
    }
    
    private lazy var tableUpdater = TableUpdater(tableView)
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel.fetchData(reset: true)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    private func setupSearchController() {
        searchController = UISearchController()
        searchController?.delegate = self
        
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.autocapitalizationType = .none
        searchController?.searchBar.delegate = self
        searchController?.hidesNavigationBarDuringPresentation = true
                
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    private func setupView() {
        title = R.string.localizable.assetsTitle()
        setupSearchController()
        setupTableView()
        view.backgroundColor = R.color.grayBg()
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchData(reset: true)
    }
    
    public init(viewModel: AssetsListViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupViewModel()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AssetsListViewController: AssetsListViewModelDelegate {
    func viewModel(_ viewModel: AssetsListViewModelInterface, didUpdateDataSource updateType: TableViewUpdateType) {
        refreshControl.endRefreshing()
        tableUpdater.update(actions: [updateType])
    }
    
    func viewModel(_ viewModel: AssetsListViewModelInterface, didFailWithError message: String) {
        refreshControl.endRefreshing()
        showFailedAlert(message: message)
    }
}

extension AssetsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.assetsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(AssetCell.self, indexPath: indexPath)
        cell.setData(viewModel.getAssetModel(forCellAt: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 3 > viewModel.assetsCount {
            viewModel.fetchData(reset: false)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showDetails(viewModel.getAssetModel(forCellAt: indexPath.row))
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AssetsListViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    @objc private func performSearch(_ text: String?) {
        viewModel.setFilter(text)
        viewModel.fetchData(reset: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        let text = searchController.searchBar.text
        self.perform(#selector(performSearch), with: text, afterDelay: 0.5)
    }
}
