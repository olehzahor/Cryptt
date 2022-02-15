// 
//

import UIKit

protocol AssetDetailsViewInterface: UIView {
    var delegate: AssetDetailsViewDelegate? { get set }
    func setPrice(_ price: Double?, delta: Double?)
    func setMarketCap(_ marketCap: Double?, supply: Double?, volume: Double?)
    func setChart(data: [Double])
}

protocol AssetDetailsViewDelegate: AnyObject {
    
}

class AssetDetailsView: UIView {
    weak var delegate: AssetDetailsViewDelegate?
    
    private let titleLabel = UILabel {
        $0.font = .systemFont(ofSize: 64, weight: .light)
        $0.textAlignment = .center
    }
    
    private let subtitleLabel = UILabel {
        $0.font = .preferredFont(forTextStyle: .title2)
        $0.textAlignment = .center
    }
    
    private let chartView = ChartView {
        $0.snp.makeConstraints { $0.height.equalTo(200) }
        $0.isHidden = true
    }
    
    private let tableView = UITableView {
        $0.alwaysBounceVertical = false
    }
    
    private let marketCapRow = KeyValueRowView {
        $0.setKey(R.string.localizable.marketCap())
    }
    
    private let supplyRow = KeyValueRowView {
        $0.setKey(R.string.localizable.supply())
    }
    
    private let volumeRow = KeyValueRowView {
        $0.setKey(R.string.localizable.volume())
    }
    
    private lazy var mainStack = UIStackView {
        $0.axis = .vertical
        $0.spacing = 5
        $0.addArrangedSubview(titleLabel)
        $0.addArrangedSubview(subtitleLabel)
        $0.addArrangedSubview(chartView)
        $0.addArrangedSubview(tableView)
        $0.addArrangedSubview(marketCapRow)
        $0.setCustomSpacing(0, after: marketCapRow)
        $0.addArrangedSubview(supplyRow)
        $0.setCustomSpacing(0, after: supplyRow)
        $0.addArrangedSubview(volumeRow)
    }
    
    private func setupView() {
        backgroundColor = R.color.grayBg()
        
        addSubview(mainStack)
        mainStack.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
    }

    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AssetDetailsView: AssetDetailsViewInterface {
    func setMarketCap(_ marketCap: Double?, supply: Double?, volume: Double?) {
        marketCapRow.setValue(CRNumberFormatter.formatCurrency(marketCap))
        supplyRow.setValue(CRNumberFormatter.formatCurrency(supply))
        volumeRow.setValue(CRNumberFormatter.formatCurrency(volume))
    }
    
    func setPrice(_ price: Double?, delta: Double?) {
        titleLabel.text = CRNumberFormatter.formatCurrency(price)
        subtitleLabel.text = CRNumberFormatter.formatPercents(delta)
        subtitleLabel.textColor = (delta ?? 0) >= 0 ? .green : .red
    }
    
    func setChart(data: [Double]) {
        chartView.setData(data)
        chartView.isHidden = false
    }
}
