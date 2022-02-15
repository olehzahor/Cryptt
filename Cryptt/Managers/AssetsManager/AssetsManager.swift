//
//  AssetsManager.swift
//  Cryptt
//
//  Created by Oleh Zahoriansky on 15.02.2022.
//

import Foundation

protocol AssetsManagerInterface {
    func resetCurrentPage()
    func getAssets(filter: String?, pageSize: Int,
                   completion: @escaping (APIResponse<[Asset]>) -> Void)
    func getAsset(id: String, completion: @escaping (APIResponse<Asset>) -> Void)
    func getAssetHistory(assetId: String,
                         completion: @escaping (APIResponse<[AssetHistoryItem]>) -> Void)
}

class AssetsManager: AssetsManagerInterface {
    private let assetsService: AssetsServiceInterface
    private var currentOffset = 0
    
    func resetCurrentPage() {
        currentOffset = 0
    }
    
    func getAsset(id: String, completion: @escaping (APIResponse<Asset>) -> Void) {
        assetsService.getAsset(id: id) { response in
            switch response {
            case .success(let data):
                completion(.success(data.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getAssets(filter: String?, pageSize: Int,
                   completion: @escaping (APIResponse<[Asset]>) -> Void) {
        let data = AssetsRequest(search: filter, limit: pageSize, offset: currentOffset)
        assetsService.getAssets(data) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let collection):
                completion(.success(collection.data))
                self.currentOffset += pageSize
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getAssetHistory(assetId: String, completion: @escaping (APIResponse<[AssetHistoryItem]>) -> Void) {
        assetsService.getAssetHistory(id: assetId) { response in
            switch response {
            case .success(let collection):
                completion(.success(collection.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    init(assetsService: AssetsServiceInterface) {
        self.assetsService = assetsService
    }
}
