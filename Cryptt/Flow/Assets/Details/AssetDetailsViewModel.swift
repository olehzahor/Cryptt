// 
//

import Foundation

protocol AssetDetailsViewModelInterface {
    var delegate: AssetDetailsViewModelDelegate? { get set }
    
    var isInWatchlist: Bool { get }
    var asset: AssetCellDataModel { get }
    var prices: [Double] { get }
    
    func toggleWatchlist()
    
    func fetchData()
}

protocol AssetDetailsViewModelDelegate: AnyObject {
    func viewModelDidUpdateWatchlist(_ viewModel: AssetDetailsViewModelInterface)
    func viewModel(_ viewModel: AssetDetailsViewModelInterface,
                   didFetchPrices prices: [Double])
    func viewModel(_ viewModel: AssetDetailsViewModelInterface,
                   didFailWithError message: String)
}

class AssetDetailsViewModel: AssetDetailsViewModelInterface {
    weak var delegate: AssetDetailsViewModelDelegate?
    
    private let watchlistManager: WatchlistManagerInterface
    private let assetsManager: AssetsManagerInterface
    
    private(set) var prices: [Double] = []
    
    private(set) var asset: AssetCellDataModel
    
    var isInWatchlist: Bool {
        watchlistManager.contains(item: asset)
    }

    private func handleHistoryResponse(_ response: APIResponse<[AssetHistoryItem]>) {
        switch response {
        case .success(let data):
            let prices = data.compactMap { Double($0.priceUsd) }
            self.prices = prices
            delegate?.viewModel(self, didFetchPrices: prices)
        case .failure(let error):
            delegate?.viewModel(self, didFailWithError: error.localizedDescription)
        }
    }
    
    func fetchData() {
        assetsManager.getAssetHistory(assetId: asset.name) { [weak self] response in
            self?.handleHistoryResponse(response)
        }
    }
    
    func toggleWatchlist() {
        if !watchlistManager.contains(item: asset) {
            watchlistManager.addItem(asset)
        } else {
            watchlistManager.removeItem(withId: asset.id ?? "")
        }
        delegate?.viewModelDidUpdateWatchlist(self)
    }
    
    init(watchlistManager: WatchlistManagerInterface,
         assetsManager: AssetsManagerInterface,
         asset: AssetCellDataModel) {
        self.watchlistManager = watchlistManager
        self.assetsManager = assetsManager
        self.asset = asset
    }
}
