//
//  AssetsService.swift
//  Cryptt
//
//  Created by Oleh Zahoriansky on 15.02.2022.
//

import Foundation

protocol AssetsServiceInterface {
    func getAssets(_ data: AssetsRequest,
                   completion: @escaping (APIResponse<AssetsResponse>) -> Void)
    func getAsset(id: String, completion: @escaping (APIResponse<AssetResponse>) -> Void)
    func getAssetHistory(id: String,
                         completion: @escaping (APIResponse<AssetHistoryResponse>) -> Void)
}

class AssetsService: AssetsServiceInterface {
    private let networkManager: NetworkManagerInterface
    
    init(networkManager: NetworkManagerInterface) {
        self.networkManager = networkManager
    }

    func getAssets(_ data: AssetsRequest, completion: @escaping (APIResponse<AssetsResponse>) -> Void) {
        guard let url = try? NetworkRouter.assets.getUrl().asURL() else {
            return completion(.failure(CRError(message: "Incorrect URL")))
        }
        networkManager.callApi(url: url,
                               body: data,
                               method: .get,
                               headers: nil,
                               completion: completion)
    }
    
    func getAsset(id: String, completion: @escaping (APIResponse<AssetResponse>) -> Void) {
        guard let url = try? NetworkRouter.asset(id: id).getUrl().asURL() else {
            return completion(.failure(CRError(message: "Incorrect URL")))
        }
        networkManager.callApi(url: url,
                               body: nil,
                               method: .get,
                               headers: nil,
                               completion: completion)
    }

    func getAssetHistory(id: String, completion: @escaping (APIResponse<AssetHistoryResponse>) -> Void) {
        guard let url = try? NetworkRouter.history(id: id).getUrl().asURL() else {
            return completion(.failure(CRError(message: "Incorrect URL")))
        }
        networkManager.callApi(url: url,
                               body: ["interval": "m5"],
                               method: .get,
                               headers: nil,
                               completion: completion)
    }
}
