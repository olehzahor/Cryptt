import CoreData

protocol CoreDataManagerInterface {
    var context: NSManagedObjectContext { get }
    func save()
}

class CoreDataManager: CoreDataManagerInterface {
    private lazy var persistentContainer: NSPersistentContainer = {
        print(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                  FileManager.SearchPathDomainMask.userDomainMask, true)[0])

        let container = NSPersistentContainer(name: "Cryptt")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private(set) lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    func save() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
