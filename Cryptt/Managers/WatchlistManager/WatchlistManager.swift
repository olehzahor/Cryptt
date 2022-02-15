import Foundation
import CoreData

protocol WatchlistManagerInterface {
    var delegate: WatchlistManagerDelegate? { get set }
    
    var isEmpty: Bool { get }
    var count: Int { get }
    
    func contains(item: AssetCellDataModel) -> Bool
    func getItem(at index: Int) -> AssetCellDataModel
    func addItem(_ item: AssetCellDataModel)
    func removeItem(at index: Int)
    func removeItem(withId id: String)
}

protocol WatchlistManagerDelegate: AnyObject {
    func manager(_ manager: WatchlistManagerInterface,
                 didUpdateWatchlist updateType: NSFetchedResultsChangeType,
                 at indexPath: IndexPath?, newIndexPath: IndexPath?)
}

class WatchlistManager: NSObject, WatchlistManagerInterface {
    public weak var delegate: WatchlistManagerDelegate?
    
    private var dataManager: CoreDataManagerInterface
    
    private lazy var frc: NSFetchedResultsController<StoredAsset> = {
        let fetchRequest: NSFetchRequest<StoredAsset> = StoredAsset.fetchRequest()
        fetchRequest.sortDescriptors = [.init(key: "dateAdded", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: dataManager.context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    var count: Int { frc.fetchedObjects?.count ?? 0 }
    var isEmpty: Bool { frc.fetchedObjects?.isEmpty ?? true }
    
    private func getItemObject(at index: Int) -> StoredAsset {
        frc.object(at: IndexPath(row: index, section: 0))
    }
    
    func getItem(at index: Int) -> AssetCellDataModel {
        let storedAsset = frc.object(at: IndexPath(row: index, section: 0))
        return .init(storedAsset)
    }
    
    func addItem(_ item: AssetCellDataModel) {
        _ = StoredAsset(context: dataManager.context, item)
        dataManager.save()
    }
    
    private func removeItem(object: StoredAsset) {
        dataManager.context.delete(object)
        dataManager.save()
    }
    
    func removeItem(at index: Int) {
        removeItem(object: getItemObject(at: index))
    }
    
    func removeItem(withId id: String) {
        guard let object = getItem(withId: id) else { return }
        removeItem(object: object)
    }
    
    private func getItem(withId id: String) -> StoredAsset? {
        let fetchRequest: NSFetchRequest<StoredAsset> = StoredAsset.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "coinId == %@", id)
        let fetchedResults = try? dataManager.context.fetch(fetchRequest)
        return fetchedResults?.first
    }
    
    func contains(item: AssetCellDataModel) -> Bool {
        getItem(withId: item.id ?? "") != nil
    }
    
    init(dataManager: CoreDataManagerInterface) {
        self.dataManager = dataManager
        super.init()
        
        try? frc.performFetch()
    }
}

extension WatchlistManager: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        delegate?.manager(self, didUpdateWatchlist: type, at: indexPath, newIndexPath: indexPath)
    }
}
