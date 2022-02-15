import Foundation
import Alamofire

final class Dependencies {
    // MARK: Managers
    
    public var assetsManager: AssetsManagerInterface!
    public var networkManager: NetworkManagerInterface!
    public var dataManager: CoreDataManagerInterface!
    public var watchlistManager: WatchlistManagerInterface!
    
    // MARK: Services
    public var assetsService: AssetsServiceInterface!
    
    // MARK: - Init stack
    private func createAssetsManager() -> AssetsManagerInterface {
        AssetsManager(assetsService: assetsService)
    }
        
    private func createAssetsService(networkManager: NetworkManagerInterface) -> AssetsServiceInterface {
        AssetsService(networkManager: networkManager)
    }
    
    private func createNetworkManager() -> NetworkManagerInterface {
        let config = Session.default.session.configuration
        config.timeoutIntervalForRequest = 10
        let session = Session(configuration: config)
        return NetworkManager(session: session)
    }
    
    private func createDataManager() -> CoreDataManagerInterface {
        CoreDataManager()
    }
    
    private func createWatchlistManager() -> WatchlistManagerInterface {
        WatchlistManager(dataManager: dataManager)
    }
    
    public init() {
        self.networkManager = createNetworkManager()
        self.assetsService = createAssetsService(networkManager: networkManager)
        self.assetsManager = createAssetsManager()
        self.dataManager = createDataManager()
        self.watchlistManager = createWatchlistManager()
    }
}
