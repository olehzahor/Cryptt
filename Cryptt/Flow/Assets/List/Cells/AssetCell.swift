//
//  AssetCell.swift
//  Cryptt
//
//  Created by Oleh Zahoriansky on 15.02.2022.
//

import UIKit
import SDWebImage

protocol AssetCellInterface: UIView {
    func setAsset(symbol: String, name: String)
    func setAsset(iconUrl: String?)
    func setPrice(_ price: Double?, delta: Double?)
}

protocol AssetCellDelegate: AnyObject {
    
}

class AssetCell: UITableViewCell {
    weak var delegate: AssetCellDelegate?
    
    private let separator = UIView {
        $0.snp.makeConstraints { $0.height.equalTo(1) }
        $0.backgroundColor = .lightGray.withAlphaComponent(1/2)
    }
    
    private let pictureView = UIImageView {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.snp.makeConstraints { $0.width.height.equalTo(60) }
    }
    
    private let titleLabel = UILabel {
        $0.font = .preferredFont(forTextStyle: .title2)
    }
    
    private let subtitleLabel = UILabel {
        $0.font = .preferredFont(forTextStyle: .footnote)
    }
    
    private lazy var textsStack = UIStackView {
        $0.axis = .vertical
        $0.spacing = 3.4
        $0.addArrangedSubview(titleLabel)
        $0.addArrangedSubview(subtitleLabel)
    }
    
    private let priceLabel = UILabel {
        $0.font = .preferredFont(forTextStyle: .title2)
        $0.textColor = .gray
        $0.textAlignment = .right
    }

    private let priceDeltaLabel = UILabel {
        $0.font = .preferredFont(forTextStyle: .body)
        $0.textColor = .gray
        $0.textAlignment = .right
    }
    
    private lazy var priceStack = UIStackView {
        $0.axis = .vertical
        $0.spacing = 7
        $0.addArrangedSubview(priceLabel)
        $0.addArrangedSubview(priceDeltaLabel)
    }

    private let chevronView = UIImageView {
        $0.image = R.image.chevron()
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints {
            $0.width.equalTo(10)
            $0.height.equalTo(14)
        }
    }
    
    private func setupPictureView() {
        contentView.addSubview(pictureView)
        pictureView.snp.makeConstraints {
            $0.leading.top.bottom.equalTo(contentView.layoutMarginsGuide)
        }
    }
    
    private func setupChevronView() {
        contentView.addSubview(chevronView)
        chevronView.snp.makeConstraints {
            $0.trailing.centerY.equalTo(contentView.layoutMarginsGuide)
        }
    }
    
    private func setupPriceStack() {
        contentView.addSubview(priceStack)
        priceStack.snp.makeConstraints {
            $0.trailing.equalTo(chevronView.snp.leading).offset(-12)
            $0.centerY.equalTo(contentView.layoutMarginsGuide)
        }
    }
    
    private func setupTextsStack() {
        contentView.addSubview(textsStack)
        textsStack.snp.makeConstraints {
            $0.leading.equalTo(pictureView.snp.trailing).offset(16)
            $0.trailing.lessThanOrEqualTo(priceStack.snp.leading).offset(-16)
            $0.centerY.equalTo(contentView.layoutMarginsGuide)
        }
    }
    
    private func setupSeparator() {
        contentView.addSubview(separator)
        separator.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(textsStack)
        }
    }
    
    private func setupView() {
        setupPictureView()
        setupChevronView()
        setupPriceStack()
        setupTextsStack()
        setupSeparator()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AssetCell: AssetCellInterface {
    func setAsset(symbol: String, name: String) {
        titleLabel.text = symbol
        subtitleLabel.text = name
    }
    
    func setAsset(iconUrl: String?) {
        pictureView.setImage(url: iconUrl, placeholder: R.image.cryptoiconPlaceholder())
    }
    
    func setPrice(_ price: Double?, delta: Double?) {
        priceLabel.text = CRNumberFormatter.formatCurrency(price)
        priceDeltaLabel.text = CRNumberFormatter.formatPercents(delta)
        priceDeltaLabel.textColor = (delta ?? 0) >= 0 ? .green : .red
    }
}
