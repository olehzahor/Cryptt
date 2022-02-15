// 
//

import Foundation
import CoreData

protocol WatchlistViewModelInterface {
    var delegate: WatchlistViewModelDelegate? { get set }
    
    var assetsCount: Int { get }
    func getAssetModel(forCellAt index: Int) -> AssetCellDataModel
    func removeItem(at index: Int)
    
    func fetchData()
}

protocol WatchlistViewModelDelegate: AnyObject {
    func viewModel(_ viewModel: WatchlistViewModelInterface,
                   didUpdateDataSource updateType: TableViewUpdateType)
    func viewModel(_ viewModel: WatchlistViewModelInterface,
                   didFailWithError message: String)
}

class WatchlistViewModel: WatchlistViewModelInterface {
    weak var delegate: WatchlistViewModelDelegate?
    
    private var watchlistManager: WatchlistManagerInterface
    private var assetsManager: AssetsManagerInterface

    private var items = [AssetCellDataModel]()
    
    var assetsCount: Int {
        items.count
    }
    
    func getAssetModel(forCellAt index: Int) -> AssetCellDataModel {
        items[index]
    }
    
    func removeItem(at index: Int) {
        watchlistManager.removeItem(at: index)
        items.remove(at: index)
    }
    
    func fetchData() {
        items = []
        let group = DispatchGroup()
        for index in 0..<watchlistManager.count {
            let storedItem = watchlistManager.getItem(at: index)
            items.append(storedItem)
            group.enter()
            assetsManager.getAsset(id: storedItem.id ?? "") { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(let data):
                    let item = AssetCellDataModel(data)
                    self.items[index] = item
                case .failure(let error):
                    print(error)
                }
                group.leave()
            }
        }
        delegate?.viewModel(self, didUpdateDataSource: .reloadData)
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.delegate?.viewModel(self, didUpdateDataSource: .reloadData)
        }
    }
    
    init(watchlistManager: WatchlistManagerInterface, assetsManager: AssetsManagerInterface) {
        self.watchlistManager = watchlistManager
        self.assetsManager = assetsManager
        (watchlistManager as? WatchlistManager)?.delegate = self
    }
}

extension WatchlistViewModel: WatchlistManagerDelegate {
    func manager(_ manager: WatchlistManagerInterface, didUpdateWatchlist updateType: NSFetchedResultsChangeType,
                 at indexPath: IndexPath?, newIndexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        switch updateType {
        case .insert:
            delegate?.viewModel(self, didUpdateDataSource: .insertRows(indexPaths: [indexPath]))
        case .delete:
            delegate?.viewModel(self, didUpdateDataSource: .deleteRows(indexPaths: [indexPath]))
        case .move:
            delegate?.viewModel(self, didUpdateDataSource: .reloadData)
        case .update:
            delegate?.viewModel(self, didUpdateDataSource: .reloadRows(indexPaths: [indexPath]))
        @unknown default:
            return
        }
    }
}
