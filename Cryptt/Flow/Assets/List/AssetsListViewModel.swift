// 
//

import Foundation

protocol AssetsListViewModelInterface {
    var delegate: AssetsListViewModelDelegate? { get set }
    
    var assetsCount: Int { get }
    func getAssetModel(forCellAt index: Int) -> AssetCellDataModel

    func fetchData(reset: Bool)
    func setFilter(_ filter: String?)
}

protocol AssetsListViewModelDelegate: AnyObject {
    func viewModel(_ viewModel: AssetsListViewModelInterface,
                   didUpdateDataSource updateType: TableViewUpdateType)
    func viewModel(_ viewModel: AssetsListViewModelInterface,
                   didFailWithError message: String)
}

class AssetsListViewModel: AssetsListViewModelInterface {
    weak var delegate: AssetsListViewModelDelegate?
    
    private var isFetching: Bool = false
    
    private let pageSize = 10
    private var filter: String?
    
    private var assetsManager: AssetsManagerInterface
    private var assetModels = [Asset]()

    var assetsCount: Int {
        assetModels.count
    }
    
    func getAssetModel(forCellAt index: Int) -> AssetCellDataModel {
        .init(assetModels[index])
    }
    
    private func handleAssetsResponse(_ response: APIResponse<[Asset]>) {
        switch response {
        case .success(let newAssets):
            assetModels += newAssets
        case .failure(let error):
            delegate?.viewModel(self, didFailWithError: error.localizedDescription)
        }
        delegate?.viewModel(self, didUpdateDataSource: .reloadData)
        isFetching = false
    }
    
    func setFilter(_ filter: String?) {
        self.filter = filter
        resetAssets()
    }
    
    private func resetAssets() {
        assetModels = []
        assetsManager.resetCurrentPage()
    }
    
    func fetchData(reset: Bool) {
        guard !isFetching else { return }
        if reset { resetAssets() }
        isFetching = true
        assetsManager.getAssets(filter: filter, pageSize: pageSize) { [weak self] response in
            self?.handleAssetsResponse(response)
        }
    }

    init(assetsManager: AssetsManagerInterface) {
        self.assetsManager = assetsManager
    }
}
