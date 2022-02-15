//
//  AssetCellDataModel.swift
//  Cryptt
//
//  Created by Oleh Zahoriansky on 15.02.2022.
//

import Foundation
import CoreData

struct AssetCellDataModel {
    let id: String?
    let imageUrl: String?
    let symbol: String
    let name: String
    let price: Double?
    let delta: Double?
    let marketCap: Double?
    let supply: Double?
    let volume: Double?
}

extension AssetCell {
    func setData(_ model: AssetCellDataModel) {
        setAsset(symbol: model.symbol, name: model.name)
        setAsset(iconUrl: model.imageUrl)
        setPrice(model.price, delta: model.delta)
    }
}

extension AssetDetailsViewInterface {
    func setData(_ model: AssetCellDataModel) {
        setPrice(model.price, delta: model.delta)
        setMarketCap(model.marketCap, supply: model.supply, volume: model.volume)
    }
}

extension AssetCellDataModel {
    init(_ model: Asset) {
        self.id = model.id
        self.name = model.name
        self.symbol = model.symbol
        self.imageUrl = IconsManager.getIconUrl(forSymbol: model.symbol)
        self.price = Double(model.priceUsd ?? "") ?? 0.0
        self.delta = Double(model.changePercent24Hr ?? "") ?? 0.0
        self.marketCap = Double(model.marketCapUsd ?? "") ?? 0.0
        self.supply = Double(model.supply ?? "") ?? 0.0
        self.volume = Double(model.volumeUsd24Hr ?? "") ?? 0.0
    }
    
    init(_ storedAsset: StoredAsset) {
        self.init(id: storedAsset.coinId,
                  imageUrl: IconsManager.getIconUrl(forSymbol: storedAsset.symbol ?? ""),
                  symbol: storedAsset.symbol ?? "",
                  name: storedAsset.name ?? "",
                  price: nil, delta: nil,
                  marketCap: nil, supply: nil, volume: nil)
    }
}

extension StoredAsset {
    convenience init(context: NSManagedObjectContext, _ model: AssetCellDataModel) {
        self.init(context: context)
        self.symbol = model.symbol
        self.name = model.name
        self.coinId = model.id ?? ""
        self.dateAdded = Date()
    }
}
