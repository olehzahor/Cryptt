// 
//

import UIKit

class AssetDetailsViewController: UIViewController {
    private let rootView: AssetDetailsViewInterface
    private var viewModel: AssetDetailsViewModelInterface
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateWatchlistButton()
        viewModel.fetchData()
    }
    
    @objc private func watchlistButtonTouched() {
        viewModel.toggleWatchlist()
    }
    
    private func updateWatchlistButton() {
        let image = viewModel.isInWatchlist ? R.image.heartFill() : R.image.heart()
        let button = UIBarButtonItem(image: image,
                                     style: .plain,
                                     target: self,
                                     action: #selector(watchlistButtonTouched))
        navigationItem.rightBarButtonItem = button
    }
    
    private func setupView() {
        view = rootView
        rootView.delegate = self
        viewModel.delegate = self
        
        rootView.setData(viewModel.asset)
        title = viewModel.asset.name
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    public init(view: AssetDetailsViewInterface,
                viewModel: AssetDetailsViewModelInterface) {
        self.rootView = view
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AssetDetailsViewController: AssetDetailsViewDelegate {
    
}

extension AssetDetailsViewController: AssetDetailsViewModelDelegate {
    func viewModelDidUpdateWatchlist(_ viewModel: AssetDetailsViewModelInterface) {
        updateWatchlistButton()
    }
    
    func viewModel(_ viewModel: AssetDetailsViewModelInterface, didFetchPrices prices: [Double]) {
        print(prices)
        rootView.setChart(data: prices)
    }
    
    func viewModel(_ viewModel: AssetDetailsViewModelInterface, didFailWithError message: String) {
        showFailedAlert(message: message)
    }
}
