import UIKit

// MARK: UICollectionView

extension UICollectionView {

    /// Register a class for use in creating new collection view cells.
    ///
    /// String representation of class is used as identifier
    /// - Parameter cellClass: CellClass to register
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }

    /// Returns a reusable cell object of speficied type located by its identifier
    ///
    /// If custom cell has not been registered then assertion is occured and new created cell is returned as fallback
    /// - Parameter cellClass: Custom type of cell
    /// - Parameter indexPath: The index path specifying the location of the cell
    func dequeue<T: UICollectionViewCell>(_ cellClass: T.Type, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: cellClass), for: indexPath) as? T else {
            assertionFailure("Cell is not registered")
            return T()
        }
        return cell
    }

    /// Register a class for use in creating new collection view supplementary views.
    ///
    /// String representation of class is used as identifier
    /// - Parameter viewClass: UICollectionReusableView class to register
    /// - Parameter kind: one of UICollectionView.elementKindSectionHeader or *Footer
    private func registerSupplementary<T: UICollectionReusableView>(_ viewClass: T.Type, kind: String) {
        register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: viewClass))
    }

    /// Returns a reusable view of speficied type located by its kind
    ///
    /// If custom view has not been registered then assertion is occured and new created view is returned as fallback
    /// - Parameter viewClass: Custom type of reusable view
    /// - Parameter kind: Either UICollectionView.elementKindSectionHeader or *Footer
    /// - Parameter indexPath: The index path specifying the location of the cell
    private func dequeueSupplementary<T: UICollectionReusableView>(_ viewClass: T.Type, kind: String, for indexPath: IndexPath) -> T {
        let id = String(describing: viewClass)
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? T else {
            assertionFailure("Supplementary view is not registered")
            return T()
        }
        return view
    }

    /// Register a class for use in creating new collection view supplementary views - headers.
    ///
    /// String representation of class is used as identifier
    /// - Parameter viewClass: UICollectionReusableView class to register
    func registerHeader<T: UICollectionReusableView>(_ viewClass: T.Type) {
        registerSupplementary(viewClass, kind: UICollectionView.elementKindSectionHeader)
    }

    /// Register a class for use in creating new collection view supplementary views - footers.
    ///
    /// String representation of class is used as identifier
    /// - Parameter viewClass: UICollectionReusableView class to register
    func registerFooter<T: UICollectionReusableView>(_ viewClass: T.Type) {
        registerSupplementary(viewClass, kind: UICollectionView.elementKindSectionFooter)
    }

    /// Returns a reusable header view of speficied type located by its kind
    ///
    /// If custom view has not been registered then assertion is occured and new created view is returned as fallback
    /// - Parameter viewClass: Custom type of reusable view
    /// - Parameter indexPath: The index path specifying the location of the cell
    func dequeHeader<T: UICollectionReusableView>(_ viewClass: T.Type, for indexPath: IndexPath) -> T {
        return dequeueSupplementary(viewClass, kind: UICollectionView.elementKindSectionHeader, for: indexPath)
    }

    /// Returns a reusable footer view of speficied type located by its kind
    ///
    /// If custom view has not been registered then assertion is occured and new created view is returned as fallback
    /// - Parameter viewClass: Custom type of reusable view
    /// - Parameter indexPath: The index path specifying the location of the cell
    func dequeFooter<T: UICollectionReusableView>(_ viewClass: T.Type, for indexPath: IndexPath) -> T {
        return dequeueSupplementary(viewClass, kind: UICollectionView.elementKindSectionFooter, for: indexPath)
    }
}

// MARK: UITableView

extension UITableView {

    /// Register a class for use in creating new table view cells.
    ///
    /// String representation of class is used as identifier
    /// - Parameter cellClass: cellClass to register
    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }

    /// Returns a reusable cell object of speficied type located by its identifier
    ///
    /// If custom cell has not been registered then assertion is occured and new created cell is returned as fallback
    /// - Parameter cellClass: Custom type of cell
    /// - Parameter indexPath: The index path specifying the location of the cell
    func dequeue<T: UITableViewCell>(_ cellClass: T.Type, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: cellClass), for: indexPath) as? T else {
            assertionFailure("Cell is not registered")
            return T()
        }
        return cell
    }

    // Improvement: Add quick help
    func register<T: UITableViewHeaderFooterView>(_ viewClass: T.Type) {
        register(viewClass, forHeaderFooterViewReuseIdentifier: String(describing: viewClass))
    }

    // Improvement: Add quick help
    func dequeue<T: UITableViewHeaderFooterView>(_ viewClass: T.Type) -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: String(describing: viewClass)) as? T else {
            assertionFailure("view \(viewClass) is not registered")
            return T()
        }
        return view
    }
}
