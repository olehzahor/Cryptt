//
//  Asset.swift
//  Cryptt
//
//  Created by Oleh Zahoriansky on 15.02.2022.
//

import Foundation

struct Asset: Codable {
    let id, rank, symbol, name: String
    let supply, maxSupply, marketCapUsd, volumeUsd24Hr: String?
    let priceUsd, changePercent24Hr, vwap24Hr: String?
    let explorer: String?
}

struct AssetResponse: Codable {
    let data: Asset
}
